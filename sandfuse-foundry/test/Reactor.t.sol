// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.16;

import "forge-std/Test.sol";
import "forge-std/console.sol";

import "../src/Reactor.sol";
import {ERC20PresetFixedSupply} from "../lib/openzeppelin-contracts/contracts/token/ERC20/presets/ERC20PresetFixedSupply.sol";
import {FusedPoRUSD} from "../src/FUSD.sol";
import {FUSDNFT} from "../src/FUSDNFT.sol";
import {Renderer} from "../src/Renderer.sol";
import {DummyOracle} from "./DummyOracle.sol";
import {DummyPoR} from "./DummyPoR.sol";
contract ReactorTest is Test {
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    ERC20PresetFixedSupply WBTC;
    FusedPoRUSD public fusd;
    DummyOracle public oracle;
    DummyPoR public por;
    FUSDNFT public nft;
    Renderer public renderer;
    Reactor public reactor;

    address public deployer;
    address public borrower;
    address public treasury;
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
        treasury = vm.addr(3);

        vm.startPrank(deployer);
        WBTC = new ERC20PresetFixedSupply("Wrapped Bitcoin", "WBTC", 100000*10**18, deployer);
        fusd = new FusedPoRUSD();
        oracle = new DummyOracle();
        por = new DummyPoR();
        renderer = new Renderer(); 
        nft = new FUSDNFT(         
                            "FUSD NFT's",
                            "FUSDPORNFTS",
                            address(treasury),
                            address(oracle),
                            address(renderer)
                        );
        reactor = new Reactor(
            address(WBTC), address(nft), address(oracle), address(fusd), address(por), address(treasury)
        );
        // minter roles need to be assigned to the reactor
        nft.grantRole(MINTER_ROLE, address(reactor));
        fusd.grantRole(MINTER_ROLE, address(reactor));
        
        //transfer 100 BTC to borrower
        WBTC.transfer(address(borrower), 100*10**decimals);
        oracle.setLatestPrice(int256(1000*10**decimals));//set BTC price to 1000 USD
        vm.stopPrank();
        // vm.prank(owner);
    }
}

contract ReactorDeployment is ReactorTest {

    function testDeployment() public {
      // test that the price oracles work
        setUp();
        assertEq(uint256(oracle.getLatestPrice()), 1000*10**decimals);
        assertEq(WBTC.balanceOf(borrower), 100*10**decimals);
        assertTrue(true);
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