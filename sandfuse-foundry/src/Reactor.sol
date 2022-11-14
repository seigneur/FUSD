// SPDX-License-Identifier: MIT
pragma solidity 0.8.16;
import "openzeppelin-contracts/security/ReentrancyGuard.sol";
import "openzeppelin-contracts/token/ERC20/utils/SafeERC20.sol";
import "./interfaces/IERC20BurnableUpgradeable.sol";
import "./interfaces/IFusdNFT.sol";
import "./Vault.sol";
import "./interfaces/IVault.sol";

contract Reactor is ReentrancyGuardUpgradeable, Initializable {
    using SafeERC20Upgradeable for IERC20;
    using SafeERC20Upgradeable for IERC20BurnableUpgradeable;

    struct FUSDInfo {
        uint256 balance;
        uint256 amount;
    }

    address immutable public FUSD_NFT;
    IFusdNFT fusdNFT;
    address immutable public collateral;
    address immutable oracleAddress;
    uint256 durationForMaturity;
    address immutable fusdERC20;

    function constructor(address _collateral, address _fusdNFT, address _oracle, address _fusdERC20) {
        collateral = _collateral;
        oracleAddress = _oracle;
        fusdNFT = IFusdNFT(address(_fusdNFT));
        fusdERC20 = _fusdERC20
    }

    function borrow(uint256 amount)
        external
        nonReentrant
        returns (bool)
    {
        uint256 forgePrice = uint256(
            priceFromOracle(oracleAddress)
        );
        //allow to borrow 80% Value
        uint256 fusdAmt = ((amount *
            80 * 
            uint256(forgePrice)) / (100 * (10**decimals * 10**decimals))) *
            (10**18);

        //move the funds to a vault to keep funds segregated
        address vaultCollateral = generateVault();
        IERC20(address(collateralAddress)).safeTransferFrom(
            msg.sender,
            vaultCollateral,
            amount
        );

        IERC20Burnable(address(fusdERC20)).mint(msg.sender, fusdAmt);

        uint256 tokenId = mintFUSDNFT(
            amount,
            0,
            forgePrice,
            durationForMaturity,
            vaultCollateral,
            decimals
        );
        return true;
    }

    function generateVault() internal returns (address) {
        return
            address(
                new Vault{
                    salt: keccak256(
                        abi.encode(msg.sender, fusdNFT.getCurrentTokenId() + 1)
                    )
                }()
            );
    }

    function mintFUSDNFT(
        uint256 amount,
        Ratios ratioOfSteady,
        uint256 forgePrice,
        address fusdVault,
        uint decimals
    ) internal returns (uint256 tokenId) {
        tokenId = fusdNFT.safeMint(
            msg.sender,
            collateral,
            80,
            forgePrice,
            amount,
            block.timestamp + durationForMaturity,
            fusdVault,
            decimals
        );
        return tokenId;
    }

    function repay(uint256 tokenId) external nonReentrant returns (bool) {
        FUSDInfo memory _fusd;
        uint256 timeToMaturity;
        address fusdVault;

        address borrower = fusdNFT.ownerOf(tokenId); 
        (
            _fusd.amount,
            timeToMaturity,
            fusdVault
        ) = fusdNFT.getFUSD(tokenId);
        _fusd.balance = IERC20Burnable(address(fusdERC20)).balanceOf(
            msg.sender
        );

        require(_fusd.amount <= _fusd.balance, "Need more Steady");
        uint256 fusdAmount = IVault(fusdVault)
            .getBalance(collateralAddress);
        address[] memory beneficiaries = new address[](2);
        uint256[] memory beneficiaryAmounts = new uint256[](2);
        beneficiaries[0] = borrower;
        beneficiaryAmounts[0] = fusdAmount;

        if (timeToMaturity > block.timestamp) {
            require(
                borrower == msg.sender,
                "You need to be the creator!"
            );
        } else {
            beneficiaryAmounts[0] =
                (fusdAmount *
                    (20)) /
                100;
            beneficiaries[1] = msg.sender;
            beneficiaryAmounts[1] =
                (fusdAmount * 80)) /
                100;
        }
        IVault(fusdVault).mergeAndClose(
            IERC20(collateralAddress),
            beneficiaries,
            beneficiaryAmounts
        );

        IERC20Burnable(address(fusdERC20)).burnFrom(
            msg.sender,
            _fusd.amount
        );
        fusdNFT.burn(tokenId);
        return true;
    }

    //get the WBTC price from chainlink
    function priceFromOracle(address _priceOracle)
        public
        view
        returns (int256 price)
    {
        bytes memory payload = abi.encodeWithSignature("latestAnswer()");
        (, bytes memory returnData) = address(_priceOracle).staticcall(payload);
        (price) = abi.decode(returnData, (int256));
        require(
            price >= 1 && price <= 1000000000000000000000000000000,
            "Oracle price is out of range"
        );
    }
}