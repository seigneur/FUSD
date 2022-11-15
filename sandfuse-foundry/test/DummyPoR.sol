// SPDX-License-Identifier: MIT

pragma solidity ^0.8.16;

contract DummyPoR {
  constructor(){}

  function latestRoundData()
    external
    view
    returns (
      uint80 roundId,
      int256 answer,
      uint256 startedAt,
      uint256 updatedAt,
      uint80 answeredInRound
    ){
      return (0, 100000000000000000000, block.number, 100, 0);
    }
}