// SPDX-License-Identifier: MIT
pragma solidity 0.8.16;
import "openzeppelin-contracts/security/ReentrancyGuard.sol";
import "openzeppelin-contracts/token/ERC20/utils/SafeERC20.sol";
import "./interfaces/IERC20Burnable.sol";
import "./interfaces/IFusdNFT.sol";
import "./Vault.sol";
import "./interfaces/IVerifyPoR.sol";
import "forge-std/console.sol";

contract Reactor is ReentrancyGuard {
    using SafeERC20 for IERC20;
    using SafeERC20 for IERC20Burnable;

    struct FUSDInfo {
        uint256 balance;
        uint256 amount;
    }

    IFusdNFT fusdNFT;
    address immutable public collateral;
    address immutable public oracleAddress;
    address immutable public PoR;
    address immutable public TREASURY;
    address immutable fusdERC20;
    uint256 constant durationForMaturity = 94608000;
    uint constant public decimals = 18;

    constructor(address _collateral, address _fusdNFT, address _oracle, address _fusdERC20, address _por, address _treasury) {
        PoR = _por;
        collateral = _collateral;
        oracleAddress = _oracle;
        fusdNFT = IFusdNFT(address(_fusdNFT));
        fusdERC20 = _fusdERC20;
        TREASURY = _treasury;
    }

    function borrow(uint256 amount)
        external
        nonReentrant
        payable
        returns (uint256)
    {
        require(IVerifyPoR(PoR).verifyPoRCGT(), "Not enough reserves");
        require(msg.value >= 0.001 ether, "Insufficient fees to borrow!");
        payable(TREASURY).transfer(0.0008 ether);// move to treasury to fund the lending side
        block.coinbase.transfer(0.0002 ether);// pay the community, later change this to only if solo staker
        uint256 fusePrice = uint256(
            priceFromOracle(oracleAddress)
        );
        // allow to borrow 80% Value
        uint256 fusdAmt = ((amount *
            80 * 
            uint256(fusePrice)) / (100 * (10**decimals * 10**decimals))) *
            (10**decimals);

        //move the funds to a vault to keep funds segregated
        address vaultCollateral = generateVault();
        IERC20(address(collateral)).safeTransferFrom(
            msg.sender,
            vaultCollateral,
            amount
        );

        IERC20Burnable(address(fusdERC20)).mint(msg.sender, fusdAmt);

        uint256 tokenId = mintFUSDNFT(
            amount,
            fusePrice,
            vaultCollateral
        );
        return tokenId;
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
        uint256 fusePrice,
        address fusdVault
    ) internal returns (uint256 tokenId) {
        tokenId = fusdNFT.safeMint(
            msg.sender,
            amount,
            fusePrice,
            collateral,
            fusdVault
        );
        return tokenId;
    }

    function repay(uint256 tokenId) external nonReentrant returns (bool) {
        FUSDInfo memory _fusd;
        uint256 fusePrice;
        address fusdVault;
        address borrower; 
        (   
            borrower,
            _fusd.amount,
            fusePrice,
            fusdVault
        ) = fusdNFT.getFUSD(tokenId);
        _fusd.balance = IERC20Burnable(address(fusdERC20)).balanceOf(
            msg.sender
        );

        require(_fusd.amount <= _fusd.balance, "Need more FUSD");
        
        uint256 collateralAmount = Vault(fusdVault).getBalance(collateral);
        address sendToAddress = borrower;
        uint256 sendToAmount = collateralAmount;

        //Has the price decreased by 25% of initial value
        int256 maxPriceDecrease =  int256(fusePrice) - ((int256(fusePrice) * 2500) / 10_000);
        // if the borrower is above water do not let other's liquidate position
        if (priceFromOracle(oracleAddress) - maxPriceDecrease >= 0) {
            require(
                borrower == msg.sender,
                "You need to be the borrower!"
            );
        } else {
            //assuming that the msg.sender/liquidator was funded by the treasury
            //TODO: Club into one txn to swap n uniswap
            //TODO: How to handle mass liquidations
            sendToAddress = TREASURY; 
            sendToAmount = collateralAmount;
        }
        Vault(fusdVault).mergeAndClose(
            IERC20(collateral),
            sendToAddress
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
            price >= 1 && price <= 1000000000000 * 10 ** 18,
            "Oracle price is out of range"
        );
    }
}