// SPDX-License-Identifier: MIT
pragma solidity ^0.8.3;

import "openzeppelin-contracts-upgradeable/token/ERC20/IERC20Upgradeable.sol";

interface IERC20BurnableUpgradeable is IERC20Upgradeable {
    function burnFrom(address account, uint256 amount) external;
    function mint(address to, uint256 amount) external;
    function symbol() external view returns (string memory);
}