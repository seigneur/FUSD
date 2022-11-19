// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.16;

import "forge-std/Script.sol";
import {ERC20PresetFixedSupply} from "../lib/openzeppelin-contracts/contracts/token/ERC20/presets/ERC20PresetFixedSupply.sol";

import "../src/FUSDKeeper.sol";

contract DeployFUSDKeeper is Script {
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");

    ERC20PresetFixedSupply WBTC;

    FUSDKeeper public keeper;

    address por = 0x4e9fc7480c16F3FE5d956C0759eE6b4808d1F5D7; //swell PoR feed
    address oracle = 0x0C466540B2ee1a31b441671eac0ca886e051E410; // price feed - XAU/USD

    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        keeper = new FUSDKeeper(address(0x12E1d4D4c151314149b8bfF3fD6DFf395524a115), address(0x0C466540B2ee1a31b441671eac0ca886e051E410));
        vm.stopBroadcast();
    }
}
