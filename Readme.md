## Sandfuse Lending
![Design](./assets/fuse-logo.png "")

We intend to create a P2P lending platform on chain. The general design idea is as follows - 
![Design](./assets/fuse.png?raw=true "Design")

## Proof of Reserve Backed lending protocol.

1. As a user create a loan request with collateral that is backed by a Proof of Reserve
2. The system locks the underlying in a separate vault for each loan taken and mints an NFT representing the balance portion in the underlying - Fuse NFT
3. For the collateral it mints 80% FUSD tokens, the price is from a chainlink feed
4. A chainlink keeper liquidates the position by calling the Fuse NFT in case it goes under water
5. The user is free to close the position prior to liquidation
6. The NFT's can be also auctioned off on opensea if the protocol has sufficient tokens to cover the immediate call. Thus earning more protocol revenue
7. The revenue generated is converted to FUSD and funds the lenders
8. We create a token vault and incentivise FUSD-DAI/FUSD-FUSDC liquidity via giving lenders FUSD from revenue

A portion of the fess are auto converted to LINK and paid to the keeper network contract.

There is no token to be created and the system is completely self managed.

## Why Dynamic NFT's?

The dynamic NFT's represent the underlying collateral and the owner of the NFT can sell it to get back the original collateral.
In a situation where the treasury via fees has enough funds to back FUSD, it may choose to auction the NFT instead. As long as the 
reserves are available an investor may choose to buy the collateral for price appreciation in the future. It can also be used for reinsurance purposes.

TODO
1. Use Goerli to test the contract and verify that can borrow.
2. Integrate UI
3. Add Lender contracts 