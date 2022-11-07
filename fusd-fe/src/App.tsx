import { useState } from "react";
import reactLogo from "./assets/react.svg";
import "./App.css";
import { Button, Card, Collapse, Input, Stats, Tabs } from "react-daisyui";
import React from "react";

import { WagmiConfig, createClient } from 'wagmi'
import { getDefaultProvider } from 'ethers'
import {Profile} from "./components/Profile" 
const client = createClient({
  autoConnect: true,
  provider: getDefaultProvider(),
})

function App() {
  
  const [count, setCount] = useState(0);
  const [tabValue, setTabValue] = React.useState(0)
  return (
    <div className="App text-xl font-bold flex content-center justify-center h-screen w-auto">
<WagmiConfig client={client}>
      <div className="item w-128 h-auto">

        
        <div className="flex flex-col justify-center items-center h-auto w-auto">
        <div className="w-auto h-auto">
          <Profile />
        </div>
        <div className="h-8" />

          <div className="w-128 items-center  justify-center h-auto">
          <Stats className="stats-vertical lg:stats-horizontal shadow">
            <Stats.Stat>
              <Stats.Stat.Item variant="title">TVL</Stats.Stat.Item>
              <Stats.Stat.Item variant="value">31K</Stats.Stat.Item>
              <Stats.Stat.Item variant="desc">Jan 1st - Nov 1st</Stats.Stat.Item>
            </Stats.Stat>

            <Stats.Stat>
              <Stats.Stat.Item variant="title">New Txs</Stats.Stat.Item>
              <Stats.Stat.Item variant="value">4,200</Stats.Stat.Item>
              <Stats.Stat.Item variant="desc">↗︎ 400 (22%)</Stats.Stat.Item>
            </Stats.Stat>

            <Stats.Stat>
              <Stats.Stat.Item variant="title">LP Pool</Stats.Stat.Item>
              <Stats.Stat.Item variant="value">1,200</Stats.Stat.Item>
              <Stats.Stat.Item variant="desc">↘︎ 90 (14%)</Stats.Stat.Item>
            </Stats.Stat>
          </Stats>
          </div>
          <div className="item w-32 h-32">
          </div>
          <div className="w-64 justify-center h-auto">
            <Tabs variant="lifted" size="lg" value={tabValue} onChange={setTabValue}>
              <Tabs.Tab value={0}>Borrow</Tabs.Tab>
              <Tabs.Tab value={1}>Lend</Tabs.Tab>
            </Tabs>
          
          </div>
          <div className="item w-32 h-auto">
            <Card>
              <Card.Body  className={tabValue === 0 ? "items-center text-center" : "hidden"} >
                <div className="form-control">
                  <label className="label">
                    <span className="label-text">Enter amount to borrow</span>
                  </label>
                  <label className="input-group">
                    <span>Amount</span>
                    <Input type="text" placeholder="10" className="input input-bordered" />
                    <span>DAI</span>
                  </label>
                </div>
                <Card.Actions className="justify-end">
                  <Button color="primary">Borrow</Button>
                </Card.Actions>
              </Card.Body>
              <Card.Body  className={tabValue === 1 ? "items-center text-center" : "hidden"} >
                <div className="form-control">
                  <label className="label">
                    <span className="label-text">Enter amount to lend</span>
                  </label>
                  <label className="input-group">
                    <span>Amount</span>
                    <Input type="text" placeholder="10" className="input input-bordered" />
                    <span>DAI</span>
                  </label>
                </div>
                <Card.Actions className="justify-end">
                  <Button color="primary">Lend!</Button>
                </Card.Actions>
              </Card.Body>
            </Card>
          </div>
          
          <div className="h-32 w-auto"></div>
          <div className="item w-auto h-auto">
          <Collapse icon="arrow" >
            <Collapse.Title className="text-xl font-medium">
              Your loan NFT's that can be closed
            </Collapse.Title>
            <Collapse.Content>
              List of loans as dynamic NFT's that can be closed
            </Collapse.Content>
          </Collapse>
          </div>
        </div>

      </div>
      </WagmiConfig>
    </div>
  );
}

export default App;
