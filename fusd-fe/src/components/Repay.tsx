import * as React from 'react'
import { usePrepareContractWrite, useContractWrite, useWaitForTransaction } from 'wagmi'
import { ethers } from "ethers";
import configData from "../../src/assets/contracts.json";

interface RepayObj {
  tokenId:string;
}
export function Repay(repayInst: RepayObj) {
 const { config } = usePrepareContractWrite({
  address: configData.REACTOR,
  abi: [
    {
      "inputs": [
        {
          "internalType": "uint256",
          "name": "tokenId",
          "type": "uint256"
        }
      ],
      "name": "repay",
      "outputs": [
        {
          "internalType": "bool",
          "name": "",
          "type": "bool"
        }
      ],
      "stateMutability": "nonpayable",
      "type": "function"
    },
  ],
  functionName: 'repay',
  args: [ethers.BigNumber.from(repayInst.tokenId)],
 })
 const { data, write } = useContractWrite(config)
 const { isLoading, isSuccess } = useWaitForTransaction({
  hash: data?.hash,
 })
 return (
  <div>
    <button disabled={!write || isLoading} onClick={() => write?write():null}>
      {isLoading ? 'Repaying...' : 'Repay'}
    </button>
    {isSuccess && (
      <div>
        Success
      </div>
    )}
  </div>
)
}
