// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "./interfaces/IPlugin.sol";

import "./interfaces/IMembership.sol";

contract SpaceMembership is IMembership {
    function onVoted(
        address voter,
        uint256 amount,
        uint256 proposalId,
        address plugin
    ) external override {
        IPlugin(plugin).charge(voter, amount, proposalId);
    }

    function onUnVoted(
        address voter,
        uint256 amount,
        address plugin
    ) external override {}

    function beforeAction(
        address voter,
        uint256 amount,
        address plugin
    ) external view override {
        require(IPlugin(plugin).holding(voter, amount));
    }

    function addMember(
        address holder,
        uint256 allocation,
        address plugin
    ) external override {
        IPlugin(plugin).addMember(holder, allocation);
    }

    function members(
        address plugin
    ) external view override returns (address[] memory, uint256[] memory) {
        return IPlugin(plugin).members();
    }

    function distribute(uint256 proposalId, address plugin) external override {
        IPlugin(plugin).refund(proposalId);
    }
}
