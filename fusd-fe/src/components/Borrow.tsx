import * as React from 'react'
import { usePrepareContractWrite, useContractWrite, useWaitForTransaction } from 'wagmi'
import { ethers } from "ethers";

interface BorrowObj{
  amount: string;
}

export function Borrow(BorrowInst: BorrowObj) {
 const { config } = usePrepareContractWrite({
  address: '0x06d5bBd6FD6D8e56362e7866D2bc16b2200c3907',
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
