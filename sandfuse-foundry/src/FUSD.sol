// SPDX-License-Identifier: MIT
pragma solidity 0.8.16;

import "openzeppelin-contracts/token/ERC20/ERC20.sol";
import "openzeppelin-contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "openzeppelin-contracts/access/AccessControl.sol";
import "openzeppelin-contracts/token/ERC20/extensions/draft-ERC20Permit.sol";
import "openzeppelin-contracts/token/ERC20/extensions/ERC20FlashMint.sol";

contract FusedPoRUSD is ERC20, ERC20Burnable, AccessControl, ERC20Permit, ERC20FlashMint {
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");

    constructor() ERC20("Fused PoR USD", "FUSD") ERC20Permit("Fused PoR USD") {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(MINTER_ROLE, msg.sender);
    }

    function mint(address to, uint256 amount) public onlyRole(MINTER_ROLE) {
        _mint(to, amount);
    }
}