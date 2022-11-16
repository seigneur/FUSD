// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.16;

import "forge-std/Script.sol";
import "../src/FUSD.sol";
import "../src/Renderer.sol";
import "../src/FUSDNFT.sol";
import "../src/VerifyPoR.sol";
import "../src/Reactor.sol";

contract DeployReactor is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        FusedPoRUSD fusd = new FusedPoRUSD();

        vm.stopBroadcast();
    }
}
