// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "./interfaces/IPluginManager2.sol";

// Space plugins
import "./Space-plugins/SpaceRewardNFT.sol";

contract PluginManager2 is IPluginManager2 {
    function create(
        uint8 incentives,
        string memory tokenName,
        string memory tokenSymbol,
        string memory rewardURI
    ) external override returns (address) {
        address plugin;

        // incentives access code plugin
        if (incentives == 1) {
            SpaceRewardNFT rewardNft = new SpaceRewardNFT(
                tokenName,
                tokenSymbol,
                "",
                rewardURI
            );
            plugin = address(rewardNft);
        }

        return plugin;
    }
}
