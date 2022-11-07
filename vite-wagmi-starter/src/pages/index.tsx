import { formatAmount } from '@did-network/dapp-sdk'
import { Button, Input } from 'antd'
import { useNavigate } from 'react-router-dom'
import { useAccount, useBalance } from 'wagmi'

import { NetworkSwitcher } from '@/components/SwitchNetworks'
import { WalletModal } from '@/components/WalletModal'
import { useWagmi } from '@/hooks'

const Home = () => {
  const navigator = useNavigate()
  const { address } = useAccount()
  const { data: balance } = useBalance({
    addressOrName: address,
  })

  const [show, setShow] = useState(false)

  const onCancel = () => {
    setShow(false)
  }

  return (
    <div className="bg-[#1E1E1E] relative p-4 lt-md:p-8 min-h-screen flex-col-center border-2 border-zinc-50 border-solid">
      <div className="flex flex-row content-center border-2 border-zinc-50 border-solid ">
        <div>
          <Input placeholder="Amount To Borrow" />
          <p className="text-center">
            {address} <br /> {formatAmount(balance?.formatted)}
          </p>
        </div>
      </div>
      <p className="flex gap-4">
        <Button type="primary" onClick={() => setShow(true)} className="flex items-center">
          {address ? 'disconnect' : 'connect'} <span className="i-carbon:cookie"></span>
        </Button>
      </p>
      <div>
        <NetworkSwitcher />
      </div>
      <WalletModal visible={show} onCancel={onCancel} />
    </div>
  )
}

export default Home

function Item() {
  const { status } = useWagmi()

  return <span></span>
}
