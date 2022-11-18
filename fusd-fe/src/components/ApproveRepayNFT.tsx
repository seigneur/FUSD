import * as React from 'react'
import { usePrepareContractWrite, useContractWrite, useWaitForTransaction } from 'wagmi'
import configData from "../../src/assets/contracts.json";

export function ApproveRepayNFT() {
 const { config } = usePrepareContractWrite({
 address: configData.FUSDNFT,
 abi: [
  {
    "inputs": [
      {
        "internalType": "address",
        "name": "operator",
        "type": "address"
      },
      {
        "internalType": "bool",
        "name": "approved",
        "type": "bool"
      }
    ],
    "name": "setApprovalForAll",
    "outputs": [],
    "stateMutability": "nonpayable",
    "type": "function"
  },
 ],
 functionName: 'setApprovalForAll',
 args: [`0x${configData.REACTOR.substring(2)}`, true ]
 })
 const { data, write } = useContractWrite(config)
 const { isLoading, isSuccess } = useWaitForTransaction({
  hash: data?.hash,
})
 return (
  <div>
    <button disabled={!write || isLoading} onClick={() => write?write():null}>
      {isLoading ? 'Approving...' : 'Approve NFT'}
    </button>
    {isSuccess && (
      <div>
        Success
      </div>
    )}
  </div>
)
}
