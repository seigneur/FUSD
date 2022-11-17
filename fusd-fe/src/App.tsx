import { useState } from "react";
import reactLogo from "./assets/react.svg";
import "./App.css";
import {
  Button,
  Card,
  Collapse,
  Input,
  Navbar,
  Select,
  Stats,
  Tabs,
} from "react-daisyui";
import React from "react";
import porabi from "./assets/porabi.json";
console.log(porabi)
import { Profile } from "./components/Profile";
import ErrorBoundary from './components/ErrorBoundary';
import { Borrow } from './components/Borrow';
import { ApproveBorrow } from './components/ApproveBorrow';
import { FUSDNFT } from './components/FUSDNFT';
import { useAccount, useBalance, useContractRead, useNetwork } from "wagmi";
import { ethers } from "ethers";

function App() {
  const { address, isConnected } = useAccount()
  const { chain, chains } = useNetwork()
  const { data, isError, isLoading } = useBalance({
    addressOrName: address,
    chainId: chain?.id,
    token: '0x0d449521e0a92198D793669521786d32837BbF55',
    onSuccess(data) {
      console.log('Success', data)
    },
  })
  const porData:any = useContractRead({
    address: '0xDe9C980F79b636B46b9c3bc04cfCC94A29D18D19',
    abi: porabi,
    functionName: 'latestAnswer',
    onSuccess(data) {
      console.log('Success', data)
    },
  })
  const nftBal:any = useContractRead({
    address: '0x570a528a6972060c5aa202fcd2a2915300831bcb',
    abi:  [{
      "inputs": [
        {
          "internalType": "address",
          "name": "owner",
          "type": "address"
        }
      ],
      "name": "balanceOf",
      "outputs": [
        {
          "internalType": "uint256",
          "name": "",
          "type": "uint256"
        }
      ],
      "stateMutability": "view",
      "type": "function"
    },
     ],
    functionName: 'balanceOf',
    onSuccess(data) {
      console.log('nftBal - ', data)
    },
  });
  const [value, setValue] = useState("default");
  const [amountValue, setAmountValue] = useState("0");

  const [tabValue, setTabValue] = React.useState(0);
  return (
    <div className="gap-2 font">
      <ErrorBoundary>
        <Navbar className="bg-base-100 shadow-xl rounded-box">
          <Navbar.Start>
            <Button className="text-xl normal-case" color="ghost">
              Fus(e)d - Fus(e) your PoR collateral!
            </Button>
          </Navbar.Start>
          <Navbar.End>
            <Profile />
          </Navbar.End>
        </Navbar>
        <div className="App text-xl font-bold flex content-center justify-center h-screen w-auto">
          <div className="item w-128 h-auto">
            <div className="flex flex-col justify-center items-center h-auto w-auto">
              <div className="w-128 items-center  justify-center h-auto">
                <Stats className="stats-vertical lg:stats-horizontal shadow">
                  <Stats.Stat>
                    <Stats.Stat.Item variant="title">TVL</Stats.Stat.Item>
                    <Stats.Stat.Item variant="value">0K</Stats.Stat.Item>
                    <Stats.Stat.Item variant="desc">
                      Jan 1st - Nov 1st
                    </Stats.Stat.Item>
                  </Stats.Stat>

                  <Stats.Stat>
                    <Stats.Stat.Item variant="title">Proof Of Reserve</Stats.Stat.Item>
                    {/* <Stats.Stat.Item variant="value">{ethers.utils.formatUnits(porData?.data,8)}</Stats.Stat.Item> */}
                    <Stats.Stat.Item variant="desc">
                      ↗︎ 400 (22%)
                    </Stats.Stat.Item>
                  </Stats.Stat>

                  <Stats.Stat>
                    <Stats.Stat.Item variant="title">LP Pool</Stats.Stat.Item>
                    <Stats.Stat.Item variant="value">0</Stats.Stat.Item>
                    <Stats.Stat.Item variant="desc">
                      ↘︎ 90 (14%)
                    </Stats.Stat.Item>
                  </Stats.Stat>
                </Stats>
              </div>
              <div className="item w-32 h-8"></div>
              <div className="w-64 justify-center h-auto">
                <Tabs
                  variant="lifted"
                  size="lg"
                  value={tabValue}
                  onChange={setTabValue}
                >
                  <Tabs.Tab value={0}>Borrow</Tabs.Tab>
                  <Tabs.Tab value={1}>Lend</Tabs.Tab>
                </Tabs>
              </div>
              <div className="item w-32 h-auto">
                <Card>
                  <Card.Body
                    className={
                      tabValue === 0 ? "items-center text-center" : "hidden"
                    }
                  >
                    <div className="form-control">
                      <Select size="lg" value={value} onChange={setValue}>
                        <Select.Option value={"default"} disabled>
                          Choose your asset
                        </Select.Option>
                        
                        <Select.Option value={"0xd781961768e2625b2AEf0E654a21Cb71Ad2B3290"}>FWBTC</Select.Option>
                        <Select.Option value={"Bart"}>FPAX</Select.Option>
                        <Select.Option value={"Homer"}>FCGT</Select.Option>
                      </Select>
                      <label className="label">
                        <span className="label-text">
                          Enter amount to borrow
                        </span>
                      </label>
                      <label className="input-group">
                        <span>Amount</span>
                        <Input
                          type="text"
                          placeholder="10"
                          className="input input-bordered"
                          value={amountValue} onChange={(evt) => setAmountValue(evt.target.value.toString())}
                        />
                        <span>WEI</span>
                      </label>
                    </div>
                    <Card.Actions className="justify-end">
                    <Button color="primary">
                        <ApproveBorrow amount={amountValue}/>
                        </Button>
                      <Button color="primary">
                        <Borrow amount={amountValue}/>
                        </Button>
                    </Card.Actions>
                  </Card.Body>
                  <Card.Body
                    className={
                      tabValue === 1 ? "items-center text-center" : "hidden"
                    }
                  >
                    <div className="form-control">
                    <Select size="lg" value={value} onChange={setValue}>
                        <Select.Option value={"default"} disabled>
                          Choose your asset
                        </Select.Option>
                        <Select.Option value={"Homer"}>FCGT</Select.Option>
                        <Select.Option value={"0xd781961768e2625b2AEf0E654a21Cb71Ad2B3290"}>FWBTC</Select.Option>
                        <Select.Option value={"Bart"}>FPAX</Select.Option>
                      </Select>
                      
                      <label className="label">
                        <span className="label-text">Enter amount to lend</span>
                      </label>
                      <label className="input-group">
                        <span>Amount</span>
                        <Input
                          type="text"
                          placeholder="10"
                          className="input input-bordered"
                        />
                        <span>WEI</span>
                      </label>
                    </div>
                    <Card.Actions className="justify-end">
                      <Button color="primary">Lend!</Button>
                    </Card.Actions>
                  </Card.Body>
                </Card>
              </div>

              <div className="h-2 w-auto"></div>
              <div className="item w-auto h-auto">
                <Collapse icon="arrow">
                  <Collapse.Title className="text-xl font-medium">
                    Your loan NFT's that can be closed
                  </Collapse.Title>
                  <Collapse.Content>
                  <div className="grid grid-flow-col auto-cols-max">
                    <div><FUSDNFT /></div>
                    <div><FUSDNFT /></div>
                    <div><FUSDNFT /></div>
                    <div><FUSDNFT /></div>
                    
                  </div>
                  </Collapse.Content>
                </Collapse>
              </div>
            </div>
          </div>
        </div>
        </ErrorBoundary>
    </div>
  );
}

export default App;
