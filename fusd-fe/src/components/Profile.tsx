import { useAccount, useConnect, useDisconnect, useEnsName } from 'wagmi'
import { InjectedConnector } from 'wagmi/connectors/injected'
import { Button, Card, Collapse, Divider, Input, Stats, Tabs } from "react-daisyui";

export const Profile = ()  => {
 const { address, isConnected } = useAccount()
 const { data: ensName } = useEnsName({ address, chainId:1 }) //ens is available only on chain 1
 const { connect } = useConnect({
 connector: new InjectedConnector(),
 })
 const { disconnect } = useDisconnect()

 if (isConnected)
 return (
  <div>

<span>Hi, {ensName ?? address} </span> 
 <Button  onClick={() => disconnect()}>Disconnect</Button>
 </div>
 )
 return <Button onClick={() => connect()}>Connect Wallet</Button>
}
