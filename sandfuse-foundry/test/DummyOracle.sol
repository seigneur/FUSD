// SPDX-License-Identifier: MIT

pragma solidity ^0.8.16;

contract DummyOracle {
int256 price;
int256 public latestAnswer;
  constructor(){}

  function getLatestPrice() public view returns(int256) {
    return price;
  }

  function setLatestPrice(int256 _price) public {
    price = _price;
  }

  function setLatestAnswer(int256 _latestAnswer) public {
    latestAnswer = _latestAnswer;
  }
}