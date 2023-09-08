import SpaceDAOABI from '../contracts/Space.json'
import SpaceGovernanceABI from '../contracts/SpaceGovernance.json'
import { readContract, prepareWriteContract, writeContract, waitForTransaction } from '@wagmi/core'

const Governance = {
    getProposals: async function (address) {
        try {
            const lastId = await readContract({
                address: address,
                abi: SpaceGovernanceABI.abi,
                functionName: 'lastId'
            })

            const result = []

            for (let index = 1; index <= Number(lastId); index++) {
                const proposal = await readContract({
                    address: address,
                    abi: SpaceGovernanceABI.abi,
                    functionName: 'getProposal',
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

    getVoteEntries: async function (proposalId, address) {
        try {
            return await readContract({
                address: address,
                abi: SpaceGovernanceABI.abi,
                functionName: 'getVoteEntries',
                args: [proposalId]
            })
        } catch (error) {
            console.error(error);
            return null
        }
    },

    executeProposal: async function (proposalId, summary, address) {
        try {
            const config = await prepareWriteContract({
                address: address,
                abi: SpaceDAOABI.abi,
                functionName: 'executeProposal',
                args: [proposalId, summary]
            })

            const { hash } = await writeContract(config)

            return await waitForTransaction({ hash: hash })
        } catch (error) {
            console.error(error);
            return null
        }
    },

    getProposal: async function (proposalId, address) {
        try {
            return await readContract({
                address: address,
                abi: SpaceGovernanceABI.abi,
                functionName: 'getProposal',
                args: [proposalId]
            })
        } catch (error) {
            console.error(error);
            return null
        }
    },

    minDuration: async function (address) {
        try {
            return await readContract({
                address: address,
                abi: SpaceGovernanceABI.abi,
                functionName: 'minDuration'
            })
        } catch (error) {
            console.error(error);
            return null
        }
    },

    minVoting: async function (address) {
        try {
            return await readContract({
                address: address,
                abi: SpaceGovernanceABI.abi,
                functionName: 'minVoting'
            })
        } catch (error) {
            console.error(error);
            return null
        }
    },

    createProposal: async function (metadata, startedOn, endedOn, treasuryAmount, treasurySummary, address) {
        try {
            const config = await prepareWriteContract({
                address: address,
                abi: SpaceDAOABI.abi,
                functionName: 'createProposal',
                args: [metadata, startedOn, endedOn, treasuryAmount, treasurySummary]
            })

            const { hash } = await writeContract(config)

            return await waitForTransaction({ hash: hash })
        } catch (error) {
            console.error(error);
            return null
        }
    },

    voteProposal: async function (proposalId, voteEntry, votingPower, address) {
        try {
            const config = await prepareWriteContract({
                address: address,
                abi: SpaceDAOABI.abi,
                functionName: 'voteProposal',
                args: [proposalId, voteEntry, votingPower]
            })

            const { hash } = await writeContract(config)

            return await waitForTransaction({ hash: hash })
        } catch (error) {
            console.error(error);
            return null
        }
    }

}

export default Governance