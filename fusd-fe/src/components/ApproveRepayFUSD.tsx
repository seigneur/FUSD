import * as React from 'react'
import { usePrepareContractWrite, useContractWrite, useWaitForTransaction } from 'wagmi'
import configData from "../../src/assets/contracts.json";

import { ethers } from "ethers";

export function ApproveRepayFUSD() {
 const { config } = usePrepareContractWrite({
 address: configData.FUSD,
 abi: [
  {"inputs":[{"internalType":"address","name":"spender","type":"address"},{"internalType":"uint256","name":"amount","type":"uint256"}],"name":"approve","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"nonpayable","type":"function"},
 ],
 functionName: 'approve',
 args: [`0x${configData.REACTOR.substring(2)}`, ethers.BigNumber.from("11579208923316195423570985008687907853269984665640564039457584007913129639935") ]
 })
 const { data, write } = useContractWrite(config)
 const { isLoading, isSuccess } = useWaitForTransaction({
  hash: data?.hash,
})
 return (
  <div>
    <button disabled={!write || isLoading} onClick={() => write?write():null}>
      {isLoading ? 'Approving...' : 'Approve FUSD'}
    </button>
    {isSuccess && (
      <div>
        Success
      </div>
    )}
  </div>
)
}
