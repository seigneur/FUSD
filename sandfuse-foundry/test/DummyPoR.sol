// SPDX-License-Identifier: MIT

pragma solidity ^0.8.16;

import "../src/interfaces/AggregatorV3Interface.sol";
contract DummyPoR is AggregatorV3Interface {

  function decimals() external view returns (uint8){
    return 18;
  }

  function description() external view returns (string memory){
    return "WBTC";
  }

  function version() external view returns (uint256){
    return 1;
  }

  function getRoundData(uint80 _roundId)
    external
    view
    returns (
      uint80 roundId,
      int256 answer,
      uint256 startedAt,
      uint256 updatedAt,
      uint80 answeredInRound
    ){
     return (0,
      1000000000*(10**18), block.number,
      0,
      0
    );
    }
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
      return (0, 1000000000*(10**18), block.number, 100, 0);
    }
}