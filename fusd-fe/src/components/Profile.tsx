import { useAccount, useConnect, useDisconnect } from 'wagmi'
import { InjectedConnector } from 'wagmi/connectors/injected'
import { Button, Card, Collapse, Input, Stats, Tabs } from "react-daisyui";

export const Profile = ()  => {
 const { address, isConnected } = useAccount()
 const { connect } = useConnect({
 connector: new InjectedConnector(),
 })
 const { disconnect } = useDisconnect()

 if (isConnected)
 return (
  <div className="flex flex-col justify-center items-center h-auto w-auto">

<p> Hi, {address}</p> 
<p>choose a Proof Of Reserve asset and take a loan!</p>
 <div className="h-8" />
 
 <Button onClick={() => disconnect()}>Disconnect</Button>
 </div>
 )
 return <Button onClick={() => connect()}>Connect Wallet</Button>
}
