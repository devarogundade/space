// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

interface IPluginManager {
    function create(
    uint8 membership,
        uint8 incentives,
        string memory tokenName,
        string memory tokenSymbol,
        address[] memory holders,
        uint256[] memory allocations,
        string memory tokenURI
    ) external returns (address);
}
