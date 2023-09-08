import SpaceIncentivesABI from '../contracts/SpaceIncentives.json'
import { readContract, prepareWriteContract, writeContract, waitForTransaction } from '@wagmi/core'

const Incentives = {
    mint: async function (holder, allocation, plugin, address) {
        try {
            const config = await prepareWriteContract({
                address: address,
                abi: SpaceIncentivesABI.abi,
                functionName: 'mint',
                args: [holder, allocation, plugin]
            })

            const { hash } = await writeContract(config)

            return await waitForTransaction({ hash: hash })
        } catch (error) {
            console.error(error);
            return null
        }
    },

    members: async function (plugin, address) {
        try {
            return await readContract({
                address: address,
                abi: SpaceIncentivesABI.abi,
                functionName: 'members',
                args: [plugin]
            })
        } catch (error) {
            console.error(error);
            return null
        }
    }

}

export default Incentives