import SpaceDAOABI from '../contracts/Space.json'
import { readContract, prepareWriteContract, writeContract, waitForTransaction } from '@wagmi/core'

const DAO = {
    registerPlugin: async function (plugin, address) {
        try {
            const config = await prepareWriteContract({
                address: address,
                abi: SpaceDAOABI.abi,
                functionName: 'registerPlugin',
                args: [plugin]
            })

            const { hash } = await writeContract(config)

            return await waitForTransaction({ hash: hash })
        } catch (error) {
            console.error(error);
            return null
        }
    },

    unRegisterPlugin: async function (accessCode, address) {
        try {
            const config = await prepareWriteContract({
                address: address,
                abi: SpaceDAOABI.abi,
                functionName: 'unRegisterPlugin',
                args: [accessCode]
            })

            const { hash } = await writeContract(config)

            return await waitForTransaction({ hash: hash })
        } catch (error) {
            console.error(error);
            return null
        }
    },

    dao: async function (address) {
        try {
            return await readContract({
                address: address,
                abi: SpaceDAOABI.abi,
                functionName: 'dao'
            })
        } catch (error) {
            console.error(error);
            return null
        }
    },

    forcePlugin: async function (address, accessCode) {
        try {
            return await readContract({
                address: address,
                abi: SpaceDAOABI.abi,
                functionName: 'forcePlugin',
                args: [accessCode]
            })
        } catch (error) {
            console.error(error);
            return null
        }
    }
}

export default DAO