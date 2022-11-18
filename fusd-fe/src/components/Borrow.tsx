import * as React from 'react'
import { usePrepareContractWrite, useContractWrite, useWaitForTransaction } from 'wagmi'
import { ethers } from "ethers";
import configData from "../../src/assets/contracts.json";

interface BorrowObj{
  amount: string | 0;
}

export function Borrow(BorrowInst: BorrowObj) {
 const { config } = usePrepareContractWrite({
  address: configData.REACTOR,
  abi: [
    {"inputs":[{"internalType":"uint256","name":"amount","type":"uint256"}],"name":"borrow","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"payable","type":"function"},
  ],
  functionName: 'borrow',
  args: [ethers.BigNumber.from(BorrowInst.amount)],
  overrides: {
    value: ethers.utils.parseEther('0.001'),
  },
 })
 const { data, write } = useContractWrite(config)
 const { isLoading, isSuccess } = useWaitForTransaction({
  hash: data?.hash,
 })
 return (
  <div>
    <button disabled={!write || isLoading} onClick={() => write?write():null}>
      {isLoading ? 'Borrowing...' : 'Borrow'}
    </button>
    {isSuccess && (
      <div>
        Success
      </div>
    )}
  </div>
)
}
