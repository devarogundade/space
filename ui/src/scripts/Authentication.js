import { EthereumClient, w3mConnectors, w3mProvider } from '@web3modal/ethereum'
import { Web3Modal } from '@web3modal/html'
import { configureChains, createClient } from '@wagmi/core'
import { pego } from './PegoChain'
 
const PROJECT_ID = import.meta.env.VITE_PROJECT_ID
const chains = [pego]

const Authentication = {
    web3modal: null,
    wagmiClient: null,

    initialize: async function () {
        if (this.wagmiClient) return this.wagmiClient

        const { provider, webSocketProvider } = configureChains(
            chains,
            [w3mProvider({ projectId: PROJECT_ID })],
        )

        const wagmiClient = createClient({
            autoConnect: true,
            connectors: w3mConnectors({ projectId: PROJECT_ID, version: 1, chains }),
            provider: provider,
            webSocketProvider: webSocketProvider
        })

        return wagmiClient
    },

    ethereumClient: async function () {
        const wagmiClient = await this.initialize()
        return new EthereumClient(wagmiClient, chains)
    },

    openModal: async function () {
        try {
            const ethereumClient = await this.ethereumClient()
            if (!this.web3modal) {
                this.web3modal = new Web3Modal({ projectId: PROJECT_ID }, ethereumClient)

                this.web3modal.setDefaultChain(pego)
                this.web3modal.setTheme({
                    themeMode: 'dark'
                })
            }

            await this.web3modal.openModal()
        } catch (error) {
            console.error(error);
        }
    },

    userAddress: async function (callback) {
        try {
            const ethereumClient = await this.ethereumClient()
            
            ethereumClient.watchAccount((account) => {
                callback(account.address);
            })
            
            const account = ethereumClient.getAccount()
            callback(account.address)
        } catch (error) {
            console.error(error);
            return null
        }
    }
}

export default Authentication