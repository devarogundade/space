const SpaceFactory = artifacts.require("SpaceFactory")
const PluginManager = artifacts.require("PluginManager")
const PluginManager2 = artifacts.require("PluginManager2")
// const SpaceRewardNFT = artifacts.require("SpaceRewardNFT")

module.exports = async function (deployer, network, accounts) {
    if (network == 'testnet2') return
    await deployer.deploy(PluginManager)
    await deployer.deploy(PluginManager2)
    // await deployer.deploy(
    //     SpaceRewardNFT,
    //     "RRR",
    //     "RRR",
    //     "",
    //     "")
    await deployer.deploy(SpaceFactory, PluginManager.address, PluginManager2.address)
};