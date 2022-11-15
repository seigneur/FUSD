// SPDX-License-Identifier: MIT
pragma solidity 0.8.16;

import "openzeppelin-contracts/token/ERC721/ERC721.sol";
import "openzeppelin-contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "openzeppelin-contracts/utils/Counters.sol";
import "openzeppelin-contracts/access/AccessControl.sol";
import "openzeppelin-contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "openzeppelin-contracts/utils/Base64.sol";
import "./interfaces/IRenderer.sol";

contract FUSDNFT is ERC721, ERC721URIStorage, ERC721Burnable, AccessControl {
    using Counters for Counters.Counter;
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    Counters.Counter public tokenIdCounter;
    address public immutable TREASURY;
    address public immutable ORACLE;
    address public renderer; //TODO define setters
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
    constructor(
        string memory name_,
        string memory symbol_,
        address _treasury,
        address _priceOracle,
        address _renderer
    ) ERC721(name_, symbol_) {
        TREASURY = _treasury;
        ORACLE = _priceOracle;
        renderer = _renderer;
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
    ) public onlyRole(MINTER_ROLE) returns (uint256 tokenId) {
        tokenId = tokenIdCounter.current();
        tokenIdCounter.increment();
        fusedElements[tokenId] = Fused(
            _amount,
            _fusePrice,
            _collateral,
            _vault,
            _borrower
        );
        _safeMint(_borrower, tokenId); //mint the NFT position to the borrower
        return tokenId;
    }

    function burn(uint256 tokenId) public override(ERC721Burnable) {
        super.burn(tokenId);
    }

    function getCurrentTokenId() public view returns (uint256) {
        return tokenIdCounter.current();
    }

    function borrowerOf(uint256 tokenId) external view returns (address) {
        return fusedElements[tokenId].borrower;
    }

    function getFUSD(uint256 tokenId)
        external
        view
        returns (
            address,
            uint256,
            uint256,
            address
        )
    {
        Fused memory currentElement = fusedElements[tokenId];
        return (
            currentElement.borrower,
            currentElement.amount,
            currentElement.fusePrice,
            currentElement.vault
        );
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        Fused memory currentElement = fusedElements[tokenId];
        string memory name = string(
            abi.encodePacked("FUSD NFT #", Strings.toString(tokenId))
        );
        string
            memory description = "The collateral of the borrow position on FUSD represented as a NFT";
        uint256 value = uint256(priceFromOracle()) * currentElement.amount;
        return
            string(
                abi.encodePacked(
                    "data:application/json;base64,",
                    Base64.encode(
                        bytes(
                            abi.encodePacked(
                                '{"name":"',
                                name,
                                '", "description":"',
                                description,
                                '", "image": "',
                                "data:image/svg+xml;base64,",
                                IRenderer(renderer).render(
                                    tokenId,
                                    value
                                ),
                                '"}'
                            )
                        )
                    )
                )
            );
    }

    function priceFromOracle() public view returns (int256 price) {
        bytes memory payload = abi.encodeWithSignature("latestAnswer()");
        (, bytes memory returnData) = address(ORACLE).staticcall(payload);
        (price) = abi.decode(returnData, (int256));
        require(
            price >= 1 && price <= 1000000000000000000000000000000,
            "Oracle price is out of range"
        );
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId,
        uint256 batchSize
    ) internal override {
        Fused storage currentElement = fusedElements[tokenId];
        currentElement.borrower = to; // if the lending position changes change the lender
        super._beforeTokenTransfer(from, to, tokenId, batchSize);
    }

    function _burn(uint256 tokenId)
        internal
        override(ERC721, ERC721URIStorage)
    {
        super._burn(tokenId);
    }
}
