// SPDX-License-Identifier: MIT
pragma solidity 0.8.16;

import "openzeppelin-contracts-upgradeable/security/ReentrancyGuardUpgradeable.sol";
import "openzeppelin-contracts-upgradeable/proxy/utils/Initializable.sol";
import "openzeppelin-contracts-upgradeable/token/ERC20/utils/SafeERC20Upgradeable.sol";

import "./interfaces/IERC20BurnableUpgradeable.sol";
import "./interfaces/IFusdNFT.sol";
import "./Vault.sol";

import "./interfaces/IVault.sol";

contract Reactor is ReentrancyGuardUpgradeable, Initializable {
    using SafeERC20Upgradeable for IERC20;
    using SafeERC20Upgradeable for IERC20BurnableUpgradeable;

    enum Ratios {
        LOW,
        MEDIUM,
        HIGH
    }

    struct TokenInfo {
        uint256 balance;
        uint256 amount;
    }

    address public FUSD_NFT;
    IFusdNFT fusdNFT;
    address public factory;
    address public collateral;

    function initialize(address _collateral, address _fusdNFT) public initializer {
        collateral = _collateral;
        factory = msg.sender;
        fusdNFT = IFusdNFT(address(_fusdNFT));
    }

    function borrow(uint256 amount, Ratios ratioOfSteady)
        external
        nonReentrant
        returns (bool)
    {
        (
            address oracleAddress,
            uint8 fees,
            uint8 decimals,
            uint256 durationForMaturity,
            ,
            address steadyImplForChyme,
            address steadyDAOReward
        ) = IFactory(address(factory)).getChymeInfo(chyme);

        uint256 forgePrice = uint256(
            Ifactory(address(factory)).priceFromOracle(oracleAddress)
        );

        uint256 sChymeAmt = ((amount *
            (75 - (25 * uint8(ratioOfSteady))) *
            uint256(forgePrice)) / (100 * (10**decimals * 10**decimals))) *
            (10**18);

        address chymeVaultDeployed = generateVault();
        IERC20(address(chyme)).safeTransferFrom(
            msg.sender,
            chymeVaultDeployed,
            amount
        );

        IERC20Burnable(address(steadyImplForChyme)).mint(msg.sender, sChymeAmt);

        uint256 tokenId = mintElixir(
            amount,
            ratioOfSteady,
            forgePrice,
            durationForMaturity,
            chymeVaultDeployed,
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

    function mintElixir(
        uint256 amount,
        Ratios ratioOfSteady,
        uint256 forgePrice,
        uint256 durationForMaturity,
        address chymeVaultDeployed,
        uint decimals
    ) internal returns (uint256 tokenId) {
        tokenId = elixir.safeMint(
            msg.sender,
            chyme,
            (75 - (25 * uint8(ratioOfSteady))), //25,50,75
            forgePrice,
            amount,
            block.timestamp + durationForMaturity,
            chymeVaultDeployed,
            decimals
        );
        return tokenId;
    }

    function repay(uint256 tokenId) external nonReentrant returns (bool) {
        TokenInfo memory _steady;
        uint256 timeToMaturity;
        uint256 ratioOfSteady;
        address chymeVaultDeployed;

        address chymeBeneficiary = elixir.ownerOf(tokenId);
        (, uint256 fees, , , , address steadyImplForChyme, address steadyDAOReward) = Ifactory(
            address(factory)
        ).getChymeInfo(chyme);
        (
            _steady.amount,
            ratioOfSteady,
            timeToMaturity,
            chymeVaultDeployed
        ) = elixir.getSteadyRequired(tokenId);
        _steady.balance = IERC20Burnable(address(steadyImplForChyme)).balanceOf(
            msg.sender
        );

        require(_steady.amount <= _steady.balance, "Need more Steady");
        uint256 totalChymeInVaultToMerge = IVault(chymeVaultDeployed)
            .getBalance(chyme);
        address[] memory beneficiaries = new address[](2);
        uint256[] memory beneficiaryAmounts = new uint256[](2);
        beneficiaries[0] = chymeBeneficiary;
        beneficiaryAmounts[0] = totalChymeInVaultToMerge;

        if (timeToMaturity > block.timestamp) {
            require(
                chymeBeneficiary == msg.sender,
                "You need to be the creator!"
            );
        } else {
            beneficiaryAmounts[0] =
                (totalChymeInVaultToMerge *
                    (100 - (75 - (25 * ratioOfSteady)))) /
                100;
            beneficiaries[1] = msg.sender;
            beneficiaryAmounts[1] =
                (totalChymeInVaultToMerge * (75 - (25 * ratioOfSteady))) /
                100;
        }
        IVault(chymeVaultDeployed).mergeAndClose(
            IERC20(chyme),
            beneficiaries,
            beneficiaryAmounts
        );

        IERC20Burnable(address(steadyImplForChyme)).burnFrom(
            msg.sender,
            _steady.amount
        );
        performMergeActions(totalChymeInVaultToMerge , tokenId);
        return true;
    }

    function performMergeActions(uint256 amount, uint256 tokenId) internal {
        fusdNFT.burn(tokenId);
    }

    function getCollateral() public view returns (address) {
        return collateral;
    }
}