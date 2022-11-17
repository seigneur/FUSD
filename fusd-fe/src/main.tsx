import React from 'react'
import ReactDOM from 'react-dom/client'
import App from './App'
import './index.css'
import { Theme } from 'react-daisyui'
import { chain, configureChains, createClient, createStorage, WagmiConfig } from 'wagmi'
import { MetaMaskConnector } from 'wagmi/connectors/metaMask'

import { WalletConnectConnector } from 'wagmi/connectors/walletConnect'
import { jsonRpcProvider } from 'wagmi/providers/jsonRpc'
import { alchemyProvider } from 'wagmi/providers/alchemy'

const { chains, provider, webSocketProvider } = configureChains(
  [chain.mainnet, chain.arbitrum, chain.polygon, chain.goerli],
  [
    // publicProvider(),
    jsonRpcProvider({
      rpc: (chain) => {
        if (chain.id !== 97 && chain.id !== 56) return null
        return { http: chain.rpcUrls.default }
      },
    }),
    alchemyProvider({ apiKey: 'KSMix3DFlS4-Mk34sK1AJGEllu5NYx-F' })
  ]
)

const client = createClient({
  autoConnect: true,
  connectors: [
    new MetaMaskConnector({ chains }),
    new WalletConnectConnector({
      chains,
      options: {
        qrcode: true,
      },
    }),
    // new InjectedConnector({
    //   chains,
    //   options: {
    //     name: 'Injected',
    //     shimDisconnect: true,
    //   },
    // }),
  ],
  storage: createStorage({ storage: window.localStorage }),
  provider,
  webSocketProvider,
})

ReactDOM.createRoot(document.getElementById('root') as HTMLElement).render(
  <React.StrictMode>
    <WagmiConfig client={client}>
    <Theme dataTheme="valentine">
      <App />
    </Theme>
    </WagmiConfig>
  </React.StrictMode>
)
