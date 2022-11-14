// SPDX-License-Identifier: MIT
pragma solidity ^0.8.3;

import "openzeppelin-contracts/token/ERC20/IERC20.sol";

interface IVault {
    function mergeAndClose(IERC20, address[] memory, uint[] memory) external;
    function getBalance(address) external view returns(uint tokenId);
}