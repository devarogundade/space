const HDWalletProvider = require('@truffle/hdwallet-provider');

const dotenv = require("dotenv")
dotenv.config()

const MNEMONIC = process.env.MNEMONIC;

module.exports = {
  plugins: ['truffle-contract-size'],

  networks: {
    testnet: {
      provider: () => new HDWalletProvider(MNEMONIC, 'https://rpc.pegotest.net'),
      network_id: 123456,
      confirmations: 2,
      timeoutBlocks: 9999999,
      skipDryRun: true,
      networkCheckTimeout: 999999999
    },

    mainnet: {
      provider: () => new HDWalletProvider(MNEMONIC, 'https://pegorpc.com'),
      network_id: 20201022,
      confirmations: 2,
      timeoutBlocks: 9999999,
      skipDryRun: true,
      networkCheckTimeout: 999999999
    },
  },

  // Set default mocha options here, use special reporters, etc.
  mocha: {
    // timeout: 100000
  },

  // Configure your compilers
  compilers: {
    solc: {
      version: "0.8.17", // Fetch exact version from solc-bin (default: truffle's version)
      settings: { // See the solidity docs for advice about optimization and evmVersion
        optimizer: {
          enabled: true,
          runs: 200
        },
        viaIR: true,
        // evmVersion: "byzantium"
      }
    }
  }
};