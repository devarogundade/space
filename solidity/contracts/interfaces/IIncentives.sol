// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

interface IIncentives {
    function onVoted(address voter, uint256 amount, address plugin) external;

    function onUnVoted(address voter, uint256 amount, address plugin) external;

    function onProposed(
        address proposer,
        uint256 amount,
        address plugin
    ) external;

    function mint(address holder, uint256 allocation, address plugin) external;

    function members(
        address plugin
    ) external view returns (address[] memory, uint256[] memory);
}
