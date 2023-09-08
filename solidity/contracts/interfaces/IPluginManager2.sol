// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

interface IPluginManager2 {
    function create(
        uint8 incentives,
        string memory tokenName,
        string memory tokenSymbol,
        string memory rewardURI
    ) external returns (address);
}
