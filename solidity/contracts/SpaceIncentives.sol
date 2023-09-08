// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "./interfaces/IPlugin.sol";

import "./interfaces/IIncentives.sol";

contract SpaceIncentives is IIncentives {
    function onVoted(
        address voter,
        uint256 amount,
        address plugin
    ) external override {
        IPlugin(plugin).reward(voter, amount);
    }

    function onUnVoted(
        address voter,
        uint256 amount,
        address plugin
    ) external override {
        IPlugin(plugin).reward(voter, amount);
    }

    function onProposed(
        address voter,
        uint256 amount,
        address plugin
    ) external override {
        IPlugin(plugin).reward(voter, amount);
    }

    function members(
        address plugin
    ) external view override returns (address[] memory, uint256[] memory) {
        return IPlugin(plugin).members();
    }

    function mint(
        address holder,
        uint256 allocation,
        address plugin
    ) external override {
        IPlugin(plugin).addMember(holder, allocation);
    }
}
