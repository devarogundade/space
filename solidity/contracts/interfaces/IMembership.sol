// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

interface IMembership {
    function onVoted(
        address voter,
        uint256 amount,
        uint256 proposalId,
        address plugin
    ) external;

    function onUnVoted(address voter, uint256 amount, address plugin) external;

    function beforeAction(
        address voter,
        uint256 amount,
        address plugin
    ) external;

    function distribute(uint256 proposalId, address plugin) external;

    function addMember(
        address holder,
        uint256 allocation,
        address plugin
    ) external;

    function members(
        address plugin
    ) external view returns (address[] memory, uint256[] memory);
}
