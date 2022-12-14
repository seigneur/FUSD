// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.16;

import "forge-std/Script.sol";
import {ERC20PresetFixedSupply} from "../lib/openzeppelin-contracts/contracts/token/ERC20/presets/ERC20PresetFixedSupply.sol";

import "../src/FUSD.sol";
import "../src/Renderer.sol";
import "../src/FUSDNFT.sol";
import "../src/VerifyPoR.sol";
import "../src/Reactor.sol";

contract DeployReactor is Script {
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");

    ERC20PresetFixedSupply WBTC;

    FUSDNFT public nft;
    Renderer public renderer;
    Reactor public reactor;
    CLv1 public clv1;

    address por = 0x4e9fc7480c16F3FE5d956C0759eE6b4808d1F5D7; //swell PoR feed
    address oracle = 0x0C466540B2ee1a31b441671eac0ca886e051E410; // price feed - XAU/USD

    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        FusedPoRUSD fusd = new FusedPoRUSD();
        // FusedPoRUSD fusd = FusedPoRUSD(0x4972c0D934D9B3cDaC3911B5A2ef0a8d1D6aD6C4);
        //0xa05b424e984dec9bcf2750cdd26c05570020b8d4
        WBTC = new ERC20PresetFixedSupply("Fake CGT", "FCGT", 125090948, msg.sender);
        // WBTC = ERC20PresetFixedSupply(0xd781961768e2625b2AEf0E654a21Cb71Ad2B3290);
        //0x459cd30ab35a74740ae27c3e0a015f38a78c5242
        clv1 = new CLv1();
        // clv1 = CLv1(0x69B3C6038E5Da2d1e6B1CAa014031629f4A0C532);
        clv1.setup(IERC20(WBTC),AggregatorV3Interface(por));
        //0x6918187ab5f7708662208f3d19275f0feb6427a7
        renderer = new Renderer();
        //0xbc0674fa9c6c9c9f9f4161e43c28ca4ce906b8ea
        // renderer = Renderer(0xb9E0bD4d179023Ea87AE524bd21b981938C35156);
        nft = new FUSDNFT(         
                            "FUSDNFTs",
                            "FUSDPORNFTS",
                            address(oracle),
                            address(renderer)
                        );//to deploy
        // nft = FUSDNFT(0x1978D1c4476d8f0c65d1942ED7DBeccE9f4c28a6);
        //0xb4344ff6d55e9304d50136c4a2af2280ad4c8070
        reactor = new Reactor(
            address(WBTC), address(nft), address(oracle), address(fusd), address(clv1), address(msg.sender)
        );
        //0x12e1d4d4c151314149b8bff3fd6dff395524a115
        // reactor = new Reactor( 
        //     address(0xd781961768e2625b2AEf0E654a21Cb71Ad2B3290), 
        //     address(0x570A528a6972060c5AA202fcd2a2915300831bcB), 
        //     address(oracle), 
        //     address(0x4972c0D934D9B3cDaC3911B5A2ef0a8d1D6aD6C4), 
        //     address(0x090AEeB45E7E6c5587BDBe17Ef3633ef103C949C)
        // );
        // reactor - Reactor(0x01edB5047E4617f1926f22FC7133c7b0515B39E0);
        // FUSDNFT(address(nft)).grantRole(MINTER_ROLE, address(reactor));
        // FusedPoRUSD(address(fusd)).grantRole(MINTER_ROLE, address(reactor));
        FUSDNFT(address(nft)).grantRole(MINTER_ROLE, address(reactor));
        FusedPoRUSD(address(fusd)).grantRole(MINTER_ROLE, address(reactor));
        // FusedPoRUSD(0x4972c0D934D9B3cDaC3911B5A2ef0a8d1D6aD6C4).mint(address(0xd76B6BED411f7Ef187Df457382d7bF588Ed8772B), 10000000000 * 10**18);
        vm.stopBroadcast();
    }
}
