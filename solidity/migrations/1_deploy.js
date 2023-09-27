const SpaceFactory = artifacts.require("SpaceFactory")
const PluginManager = artifacts.require("PluginManager")
const PluginManager2 = artifacts.require("PluginManager2")

module.exports = async function (deployer, network, accounts) {
    // return
    await deployer.deploy(PluginManager)
    await deployer.deploy(PluginManager2)
    await deployer.deploy(SpaceFactory, PluginManager.address, PluginManager2.address)
};