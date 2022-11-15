// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.16;

import "forge-std/Test.sol";
import "forge-std/console.sol";

import "../src/Reactor.sol";
import {ERC20PresetFixedSupply} from "../lib/openzeppelin-contracts/contracts/token/ERC20/presets/ERC20PresetFixedSupply.sol";
import {FusedPoRUSD} from "../src/FUSD.sol";
import {DummyOracle} from "./DummyOracle.sol";
import {DummyPoR} from "./DummyPoR.sol";
contract ReactorTest is Test {
    
    ERC20PresetFixedSupply WBTC;
    FusedPoRUSD public fusd;
    DummyOracle public oracle;
    DummyPoR public por;
    address public deployer;
    address public borrower;
    uint constant decimals = 18;

    function setUp() public {
      /** 
      1. create a test PoR token eg. WBTC, 
      2. create a mock PoR oracle
      3. create a mock price feed
      4. deploy FUSD with the above feeds and info
       */

        deployer = vm.addr(1);
        borrower = vm.addr(2);

        vm.startPrank(deployer);
        WBTC = new ERC20PresetFixedSupply("Wrapped Bitcoin", "WBTC", 10**18, deployer);
        fusd = new FusedPoRUSD();
        oracle = new DummyOracle();
        por = new DummyPoR();

        vm.stopPrank();
        // vm.prank(owner);
        // daix.transfer(address(lcBroker), 10000000000000000);
    }
}

contract ReactorDeployment is ReactorTest {

    function testDeployment() public {
      // test that the price oracles work
        setUp();
        // assertEq(lcBroker.owner(), owner, "wrong owner");
        // assertEq(daix.balanceOf(buyer), 50000000000000000);
        // assertTrue(true);
    }


}

//tests the ideal conditions
contract ReactorBorrowFlowTest is ReactorTest {
    //tests the creation of a borrow request considering that the feeds are available
    function testCreateBorrow() public {
        setUp();
        // emit log_uint(block.number); // 1

        vm.startPrank(borrower);
        vm.stopPrank();
    }

    function testCloseBorrow() public {
        setUp();

    }


}