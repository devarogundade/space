import SpaceTreasuryABI from '../contracts/SpaceTreasury.json'
import { readContract, prepareWriteContract, writeContract, waitForTransaction } from '@wagmi/core'

const DAO = {
    fundEVM: async function (summary, amount, address) {
        try {
            const config = await prepareWriteContract({
                address: address,
                abi: SpaceTreasuryABI.abi,
                functionName: 'fundEVM',
                args: [summary, { value: amount }]
            })

            const { hash } = await writeContract(config)

            return await waitForTransaction({ hash: hash })
        } catch (error) {
            console.error(error);
            return null
        }
    },

    getBalance: async function (address) {
        try {
            return await readContract({
                address: address,
                abi: SpaceTreasuryABI.abi,
                functionName: 'feed'
            })
        } catch (error) {
            console.error(error);
            return null
        }
    },

    getHistory: async function (address) {
        try {
            const lastId = await readContract({
                address: address,
                abi: SpaceTreasuryABI.abi,
                functionName: 'lastId'
            })

            const result = []

            for (let index = 1; index <= Number(lastId); index++) {
                const proposal = await readContract({
                    address: address,
                    abi: SpaceTreasuryABI.abi,
                    functionName: 'getHistory',
                    args: [index]
                })

                result.push(proposal);
            }

            return result
        } catch (error) {
            console.error(error);
            return null
        }
    },
}

export default DAO