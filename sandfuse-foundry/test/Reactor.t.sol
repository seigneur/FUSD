// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.16;

import "forge-std/Test.sol";
import "forge-std/console.sol";

import "../src/Reactor.sol";
import {ERC20PresetFixedSupply} from "../lib/openzeppelin-contracts/contracts/token/ERC20/presets/ERC20PresetFixedSupply.sol";
import {IERC20} from "../lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import {FusedPoRUSD} from "../src/FUSD.sol";
import {FUSDNFT} from "../src/FUSDNFT.sol";
import {CLv1} from "../src/VerifyPoR.sol";
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
    CLv1 public clv1;

    address public deployer;
    address public borrower;
    address public treasury;
    address public swapRouter = 0xE592427A0AEce92De3Edee1F18E0157C05861564;
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
        vm.deal(borrower, 1 ether);
        vm.startPrank(deployer);
        WBTC = new ERC20PresetFixedSupply("Wrapped Bitcoin", "WBTC", 100000*10**18, deployer);
        fusd = new FusedPoRUSD(); //need to deploy
        oracle = new DummyOracle();
        por = new DummyPoR();
        clv1 = new CLv1(); //need to deploy
        clv1.setup(IERC20(WBTC),por); //need to call
        renderer = new Renderer(); //need to deploy
        nft = new FUSDNFT(         
                            "FUSD NFT's",
                            "FUSDPORNFTS",
                            address(treasury),
                            address(oracle),
                            address(renderer)
                        );//to deploy
        reactor = new Reactor(
            address(WBTC), address(nft), address(oracle), address(fusd), address(clv1), swapRouter /* address(treasury)*/
        );//to deploy
        // minter roles need to be assigned to the reactor
        nft.grantRole(MINTER_ROLE, address(reactor));
        fusd.grantRole(MINTER_ROLE, address(reactor));
        //transfer 100 BTC to borrower
        WBTC.transfer(address(borrower), 100*10**decimals);
        oracle.setLatestPrice(int256(1000*10**18));//set BTC price to 1000 USD
        oracle.setLatestAnswer(int256(1000*10**18));//set BTC price to 1000 USD
        vm.stopPrank();
    }
}

contract ReactorDeployment is ReactorTest {

    function testDeployment() public {
      // test that the price oracles work
        // setUp();
        assertEq(uint256(oracle.getLatestPrice()), 1000*10**18);
        assertEq(WBTC.balanceOf(borrower), 100*10**decimals);
        assertTrue(true);
    }


}

//tests the ideal conditions
contract ReactorBorrowFlowTest is ReactorTest {
    //tests the creation of a borrow request considering that the feeds are available
    function testCreateBorrow() public {
        // setUp();
        // emit log_uint(block.number); // 1

        vm.startPrank(borrower);
        //do approval of transfer and then call the contract
        WBTC.approve(address(reactor),100*10**18);
        reactor.borrow{value:0.1 ether}(100*10**18);
        assertTrue(true);

        vm.stopPrank();
    }

    function testCloseBorrow() public {

        vm.startPrank(borrower);
        //do approval of transfer and then call the contract
        WBTC.approve(address(reactor),100*10**18);
        (uint tokenId) = reactor.borrow{value:0.1 ether}(100*10**18);
        // check the balance
        vm.roll(100);
        fusd.approve(address(reactor),100*10**18);
        nft.approve(address(reactor), tokenId);
        reactor.repay(tokenId);
        assertTrue(true);

        vm.stopPrank();

    }
}
