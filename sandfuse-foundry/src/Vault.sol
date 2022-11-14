// SPDX-License-Identifier: MIT
pragma solidity 0.8.16;

import "openzeppelin-contracts-upgradeable/token/ERC20/IERC20Upgradeable.sol";
import "openzeppelin-contracts-upgradeable/access/OwnableUpgradeable.sol";

contract Vault is OwnableUpgradeable {
  function mergeAndClose(IERC20Upgradeable token, address[] memory payTo,uint[] memory amounts) public onlyOwner {
    require(payTo.length == amounts.length, "Mismatch in allocation");
    for(uint i = 0; i < payTo.length;) {
      if(payTo[i] != address(0)){
       require(token.transfer(payTo[i], token.balanceOf(address(this))), "Transfer failed");
      }
      i++;
    }
    selfdestruct(payable(msg.sender));
  }
  
  function getBalance(address token) public view returns (uint balance){
    return IERC20Upgradeable(token).balanceOf(address(this));
  }
}