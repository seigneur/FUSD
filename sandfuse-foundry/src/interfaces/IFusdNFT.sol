// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

import "openzeppelin-contracts/token/ERC721/IERC721.sol";

interface IFusdNFT is IERC721 {
    function burn(uint256 tokenId) external;
    function getCurrentTokenId() external view returns (uint256);
    function borrowerOf(uint tokenId) external view returns (address);
    function getFUSD(uint256 tokenId) external view returns(address, uint256, uint256, address); 
    function safeMint(        
        address _borrower,        
        uint256 _amount,
        uint256 _forgePrice,
        address _collateral,
        address _vault ) external returns(uint256);
}