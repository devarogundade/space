import SpaceMembershipABI from '../contracts/SpaceMembership.json'
import { readContract, prepareWriteContract, writeContract, waitForTransaction } from '@wagmi/core'

const Members = {
    addMember: async function (holder, allocation, plugin, address) {
        try {
            const config = await prepareWriteContract({
                address: address,
                abi: SpaceMembershipABI.abi,
                functionName: 'addMember',
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
                abi: SpaceMembershipABI.abi,
                functionName: 'members',
                args: [plugin]
            })
        } catch (error) {
            console.error(error);
            return null
        }
    }

}

export default Members