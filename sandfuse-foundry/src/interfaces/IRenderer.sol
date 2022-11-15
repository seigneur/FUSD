pragma solidity ^0.8.16;

interface IRenderer {
function render(uint256 _tokenId, uint256 _value) external pure returns (string memory);
}