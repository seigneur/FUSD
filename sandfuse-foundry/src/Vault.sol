// SPDX-License-Identifier: MIT
pragma solidity 0.8.16;

import "openzeppelin-contracts/token/ERC20/IERC20.sol";
import "openzeppelin-contracts/access/Ownable.sol";

contract Vault is Ownable {
  function mergeAndClose(IERC20 token, address payTo) public onlyOwner {
      if(payTo != address(0)){
       require(token.transfer(payTo, token.balanceOf(address(this))), "Transfer failed");
      }
    
    selfdestruct(payable(msg.sender));
  }
  
  function getBalance(address token) public view returns (uint balance){
    return IERC20(token).balanceOf(address(this));
  }
}