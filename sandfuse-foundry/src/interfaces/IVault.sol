// SPDX-License-Identifier: MIT
pragma solidity ^0.8.3;

import "openzeppelin-contracts-upgradeable/token/ERC20/IERC20Upgradeable.sol";

interface IVault {
    function mergeAndClose(IERC20Upgradeable, address[] memory,uint[] memory) external;
    function getBalance(address) external view returns(uint tokenId);
}