// SPDX-License-Identifier: MIT
pragma solidity 0.8.16;

import "openzeppelin-contracts/token/ERC721/ERC721.sol";
import "openzeppelin-contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "openzeppelin-contracts/utils/Counters.sol";
import "openzeppelin-contracts/access/AccessControl.sol";

contract FUSDNFT is ERC721, ERC721Burnable, AccessControl {
    using Counters for Counters.Counter;
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    Counters.Counter public tokenIdCounter;
    address immutable public TREASURY;

    struct Fused {
        uint256 amount;
        uint256 fusePrice;
        address collateral;
        address vault;
        address borrower;
    }
    mapping(uint256 => Fused) public fusedElements;

    /**
     * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
     */
    constructor(string memory name_,
        string memory symbol_, 
        address _treasury) 
        ERC721(name_, 
        symbol_
    ) {
        TREASURY = _treasury;
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _setupRole(MINTER_ROLE, msg.sender);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        virtual
        override(ERC721, AccessControl)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    function safeMint(
        address _borrower,        
        uint256 _amount,
        uint256 _fusePrice,
        address _collateral,
        address _vault
    ) public onlyRole(MINTER_ROLE) returns(uint256 tokenId) {
        tokenId = tokenIdCounter.current();
        tokenIdCounter.increment();
        fusedElements[tokenId] = Fused(
            _amount,
            _fusePrice,
            _collateral,
            _vault,
            _borrower
        );
        _safeMint(TREASURY, tokenId);
        return tokenId;
    }

    function burn(uint256 tokenId) public override(ERC721Burnable) {
        super.burn(tokenId);
    }
    
    function getCurrentTokenId() public view returns (uint256) {
        return tokenIdCounter.current();
    }

    function borrowerOf(uint tokenId) external view returns (address) {
        return fusedElements[tokenId].borrower;
    }

    function getFUSD(uint256 tokenId) external view returns(uint256, uint256, address) {
        Fused currentElement =  fusedElements[tokenId];
        return (currentElement.amount, currentElement.fusePrice, currentElement.vault);
    } 

}