// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

interface IPlugin {
    function accessCode() external view returns (uint64);

    function metadata() external view returns (string memory);

    function addMember(address holder, uint256 allocation) external;

    function removeMember(address holder) external;

    function charge(address from, uint256 amount, uint256 proposalId) external;

    function refund(uint256 proposalId) external;

    function reward(address to, uint256 amount) external;

    function holding(address holder, uint256 amount) external view returns (bool);

    function members()
        external
        view
        returns (address[] memory, uint256[] memory);
}
