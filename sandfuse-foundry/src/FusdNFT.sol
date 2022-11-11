// SPDX-License-Identifier: MIT
pragma solidity 0.8.16;

import "openzeppelin-contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";
import "openzeppelin-contracts-upgradeable/token/ERC721/extensions/ERC721BurnableUpgradeable.sol";
import "openzeppelin-contracts-upgradeable/utils/CountersUpgradeable.sol";
import "openzeppelin-contracts-upgradeable/access/AccessControlUpgradeable.sol";

contract FusdNFT is ERC721Upgradeable, ERC721BurnableUpgradeable, AccessControlUpgradeable {
    using CountersUpgradeable for CountersUpgradeable.Counter;
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    CountersUpgradeable.Counter public tokenIdCounter;

    /**
     * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
     */
    constructor(
        string memory name_,
        string memory symbol_
    ) {
        __ERC721_init(name_,symbol_);
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _setupRole(MINTER_ROLE, msg.sender);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        virtual
        override(ERC721Upgradeable, AccessControlUpgradeable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    function safeMint(
        address _to
    ) public onlyRole(MINTER_ROLE) returns(uint256 tokenId) {
        tokenId = tokenIdCounter.current();
        tokenIdCounter.increment();
        _safeMint(_to, tokenId);
    }

    function burn(uint256 tokenId) public override(ERC721BurnableUpgradeable) {
        super.burn(tokenId);
    }
}