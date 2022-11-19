# Taken from https://github.com/smartcontractkit/foundry-starter-kit/blob/main/Makefile 
-include .env

.PHONY: all test clean deploy-anvil

all: clean remove install update build

# Clean the repo
clean  :; forge clean

# Remove modules
remove :; rm -rf .gitmodules && rm -rf .git/modules/* && rm -rf lib && touch .gitmodules && git add . && git commit -m "modules"

install :; forge install smartcontractkit/chainlink-brownie-contracts && forge install openzeppelin/openzeppelin-contracts && forge install foundry-rs/forge-std

# Update Dependencies
update:; forge update

build:; forge build

test :; forge test 

snapshot :; forge snapshot

slither :; slither ./src 

format :; prettier --write src/**/*.sol && prettier --write src/*.sol

# solhint should be installed globally
lint :; solhint src/**/*.sol && solhint src/*.sol

anvil :; anvil -m 'test test test test test test test test test test test junk'

# use the "@" to hide the command from your shell 
deploy-goerli :; @forge script script/${contract}.s.sol:Deploy${contract} --rpc-url ${GOERLI_RPC_URL}  --private-key ${PRIVATE_KEY} --broadcast  -vvvv

deploy-matic :; @forge script script/${contract}.s.sol:Deploy${contract} --rpc-url ${MATIC_RPC_URL}  --private-key ${PRIVATE_KEY} --broadcast  -vvvv

# auto verification fails so use manual
verify-goerli :; forge  verify-contract --constructor-args  $(cast abi-encode "constructor(address,address,address,address,address,address)" "0xd781961768e2625b2AEf0E654a21Cb71Ad2B3290" "0x570A528a6972060c5AA202fcd2a2915300831bcB" "0x7b219F57a8e9C7303204Af681e9fA69d17ef626f" "0x4972c0D934D9B3cDaC3911B5A2ef0a8d1D6aD6C4" "0x090AEeB45E7E6c5587BDBe17Ef3633ef103C949C" "0x0ce42e1adB575e72716933008d804D37d888a5B7") --chain-id 5 --watch ${address} src/${contract}.sol:${contractName} ${ETHERSCAN_API_KEY} 
verify-matic :; forge  verify-contract --constructor-args  $(cast abi-encode "constructor(address,address,address,address,address,address)" "0xb86223e00073c5fff76bc433a258ae4334f9d100" "0x090aeeb45e7e6c5587bdbe17ef3633ef103c949c" "0x0C466540B2ee1a31b441671eac0ca886e051E410" "0x0782362bf0dec227799f17e7f9eca3a1fbb4a153" "0x0d449521e0a92198d793669521786d32837bbf55" "0x0ce42e1adB575e72716933008d804D37d888a5B7") --chain-id 137 --watch ${address} src/${contract}.sol:${contractName} ${POLYGONSCAN_API_KEY} 

# This is the private key of account from the mnemonic from the "make anvil" command
deploy-anvil :; @forge script script/${contract}.s.sol:Deploy${contract} --rpc-url http://localhost:8545  --private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80 --broadcast 

deploy-all :; make deploy-${network} contract=APIConsumer && make deploy-${network} contract=KeepersCounter && make deploy-${network} contract=PriceFeedConsumer && make deploy-${network} contract=VRFConsumerV2
