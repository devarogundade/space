// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "./interfaces/IPluginManager.sol";

// Space plugins
import "./Space-plugins/SpaceVotingNFT.sol";
import "./Space-plugins/SpaceVotingToken.sol";
import "./Space-plugins/SpaceVotingMultisig.sol";

contract PluginManager is IPluginManager {
    function create(
        uint8 membership,
        uint8 incentives,
        string memory tokenName,
        string memory tokenSymbol,
        address[] memory holders,
        uint256[] memory allocations,
        string memory tokenURI
    ) external override returns (address) {
        address plugin;

        // membership access code plugin
        if (membership == 0) {
            SpaceVotingToken votingToken = new SpaceVotingToken(
                tokenName,
                tokenSymbol,
                "",
                holders,
                allocations
            );
            plugin = address(votingToken);
        } else if (membership == 1) {
            SpaceVotingNFT votingNFT = new SpaceVotingNFT(
                tokenName,
                tokenSymbol,
                "",
                tokenURI,
                holders,
                allocations
            );
            plugin = address(votingNFT);
        } else {
            SpaceVotingMultisig multisig = new SpaceVotingMultisig("", holders);
            plugin = address(multisig);
        }

        return plugin;
    }
}
