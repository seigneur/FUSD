import { useState } from "react";
import reactLogo from "./assets/react.svg";
import "./App.css";
import { Button, Card, Input, Tabs } from "react-daisyui";
import React from "react";

function App() {
  const [count, setCount] = useState(0);
  const [tabValue, setTabValue] = React.useState(0)
  return (
    <div className="App text-xl font-bold flex content-center justify-center h-screen w-auto">

      <div className="item w-32 h-auto">
        <div className="flex flex-col justify-center items-center h-auto w-auto">
          <div className="w-64 justify-center h-auto">
            <Tabs variant="lifted" value={tabValue} onChange={setTabValue}>
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
          
        </div>

      </div>
    </div>
  );
}

export default App;
