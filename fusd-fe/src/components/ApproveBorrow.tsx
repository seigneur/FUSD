import * as React from 'react'
import { usePrepareContractWrite, useContractWrite, useWaitForTransaction } from 'wagmi'

export function ApproveBorrow({amount}) {
 const { config } = usePrepareContractWrite({
 address: '0xd781961768e2625b2AEf0E654a21Cb71Ad2B3290',
 abi: [
  {"inputs":[{"internalType":"address","name":"spender","type":"address"},{"internalType":"uint256","name":"amount","type":"uint256"}],"name":"approve","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"nonpayable","type":"function"},
 ],
 functionName: 'approve',
 args: ['0x06d5bBd6FD6D8e56362e7866D2bc16b2200c3907', amount ]
 })
 const { data, write } = useContractWrite(config)
 const { isLoading, isSuccess } = useWaitForTransaction({
  hash: data?.hash,
})
 return (
  <div>
    <button disabled={!write || isLoading} onClick={() => write?write():null}>
      {isLoading ? 'Approving...' : 'Approve'}
    </button>
    {isSuccess && (
      <div>
        Success
      </div>
    )}
  </div>
)
}
