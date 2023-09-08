import SpaceFactoryABI from '../contracts/SpaceFactory.json'
import Converter from './Converter'
import { readContract, prepareWriteContract, writeContract, waitForTransaction } from '@wagmi/core'

const Factory = {
    // address: SpaceFactoryABI.networks[123456].address,
    address: '',

    deploy: async function (metadata, holders, allocations, dao) {
        try {
            const config = await prepareWriteContract({
                address: this.address,
                abi: SpaceFactoryABI.abi,
                functionName: 'deployDAO',
                args: [
                    metadata,
                    dao.subdomain.toLocaleLowerCase(),
                    dao.threshold,
                    dao.membership,
                    dao.incentives,
                    dao.tokenName,
                    dao.tokenSymbol,
                    holders,
                    allocations,
                    dao.tokenURI,
                    dao.rewardURI,
                    Converter.toWei(dao.minVoting),
                    Converter.toWei(dao.minPropose),
                    dao.minDuration,
                    dao.earlyExecution,
                    dao.parentSubdomain
                ]
            })

            const { hash } = await writeContract(config)

            return await waitForTransaction({ hash: hash })
        } catch (error) {
            console.error(error);
            return null
        }
    },

    resolveName: async function (subdomain) {
        try {
            return await readContract({
                address: this.address,
                abi: SpaceFactoryABI.abi,
                functionName: 'resolveName',
                args: [subdomain]
            })
        } catch (error) {
            console.error(error);
            return null
        }
    },

    availability: async function (subdomain) {
        try {
            return await readContract({
                address: this.address,
                abi: SpaceFactoryABI.abi,
                functionName: 'availability',
                args: [subdomain]
            })
        } catch (error) {
            console.error(error);
            return null
        }
    },

    getDoas: async function () {
        try {
            return await readContract({
                address: this.address,
                abi: SpaceFactoryABI.abi,
                functionName: 'daos',
            })
        } catch (error) {
            console.error(error)
            return null
        }
    },

    getDoasOf: async function (owner) {
        try {
            return await readContract({
                address: this.address,
                abi: SpaceFactoryABI.abi,
                functionName: 'daosOf',
                args: [owner]
            })
        } catch (error) {
            console.error(error);
            return null
        }
    }
}

export default Factory