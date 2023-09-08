const SpaceFactory = artifacts.require("SpaceFactory")
// const SpaceRewardNFT = artifacts.require("SpaceRewardNFT")

contract("SpaceFactory", async accounts => {
    it("create dao", async () => {
        const SpaceFactory = await SpaceFactory.deployed()
        const create = await SpaceFactory.deployDAO(
            "{name: \"Matric DAO\"}",
            "test",
            50,
            0,
            1,
            "tokenName",
            "tokenSymbol",
            [accounts[0]],
            ["10000000000000"],
            "tokenURI",
            "rewardURI",
            1,
            1,
            5
        )
        const doas = await SpaceFactory.daos()
        console.log(doas);
    })
})

// contract("SpaceRewardNFT", async accounts => {
//     it("test plugin", async () => {
//         const plugin = await SpaceRewardNFT.deployed()
//         console.log(SpaceFactory.address);
//         const accessCode = await plugin.accessCode()
//         console.log(accessCode);
//     })
// })