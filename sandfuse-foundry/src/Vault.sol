// SPDX-License-Identifier: MIT
pragma solidity 0.8.16;

import "openzeppelin-contracts/token/ERC20/IERC20.sol";
import "openzeppelin-contracts/access/Ownable.sol";

contract Vault is Ownable {
  function mergeAndClose(IERC20 token, address[] memory payTo,uint[] memory amounts) public onlyOwner {
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
    return IERC20(token).balanceOf(address(this));
  }
}