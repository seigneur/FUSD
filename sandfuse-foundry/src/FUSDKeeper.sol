// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

import "@chainlink/contracts/src/v0.8/interfaces/KeeperCompatibleInterface.sol";
import "openzeppelin-contracts/access/Ownable.sol";

contract KeepersCounter is KeeperCompatibleInterface, Ownable {
    uint256 public counter;
    uint256 public immutable interval;
    uint256 public lastTimeStamp;

    address public reactor;
    address public priceOracle;

    constructor(uint256 updateInterval, address _reactor, address _priceOracle) {
        interval = updateInterval;
        lastTimeStamp = block.timestamp;
        counter = 0;
        reactor = _reactor;
        priceOracle = _priceOracle;
    }

    function setReactor(address _reactor) external onlyOwner {
        reactor = _reactor;
    }

    function setOracle(address _priceOracle) external onlyOwner {
        priceOracle = _priceOracle;
    }

    function priceFromOracle()
        internal
        view
        returns (int256 price)
    {
        require(priceOracle != address(0), "oracle not set");
        bytes memory payload = abi.encodeWithSignature("latestAnswer()");
        (, bytes memory returnData) = address(priceOracle).staticcall(payload);
        (price) = abi.decode(returnData, (int256));
        require(
            price >= 1 && price <= 1000000000000 * 10 ** 18,
            "Oracle price is out of range"
        );
    }

    function checkUpkeep(
        bytes calldata
    )
        public
        view
        override
        returns (bool upkeepNeeded, bytes memory performData)
    {
        require(reactor != address(0), "reactor not set");

        bytes memory payload = abi.encodeWithSignature("tokenLast()");
        (bool success, bytes memory returnData) = address(reactor).staticcall(payload);
        require(success);
        uint tokenLast = abi.decode(returnData, (uint));

        payload = abi.encodeWithSignature("tokenIdPrices(uint)", tokenLast);
        (success, returnData) = address(reactor).staticcall(payload);
        require(success);
        int maxPriceDecrease = abi.decode(returnData, (int));

        upkeepNeeded = priceFromOracle() < maxPriceDecrease;
        performData = abi.encode(tokenLast);
    }

    function performUpkeep(
        bytes calldata performData
    ) 
        external 
        override 
    {
        uint tokenId = abi.decode(performData, (uint));
        bytes memory payload = abi.encodeWithSignature("repay(uint256)", tokenId);
        (bool success,) = address(reactor).call(payload);
        require(success);
    }
}