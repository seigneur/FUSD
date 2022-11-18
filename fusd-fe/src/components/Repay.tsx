import * as React from 'react'
import { usePrepareContractWrite, useContractWrite, useWaitForTransaction } from 'wagmi'
import { ethers } from "ethers";

export function Repay({tokenId}) {
 const { config } = usePrepareContractWrite({
  address: '0x06d5bBd6FD6D8e56362e7866D2bc16b2200c3907',
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
  args: [tokenId],
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
