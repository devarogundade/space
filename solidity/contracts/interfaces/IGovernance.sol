// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "./../libraries/Enums.sol";
import "./../libraries/Models.sol";

interface IGovernance {
    // STATE CHANGING FUNCTIONS

    function createProposal(
        Models.Proposal memory proposal
    ) external returns (uint256);

    function endProposal(uint256 proposalId) external;

    function executeProposal(uint256 proposalId) external returns (uint256);

    function voteProposal(
        uint256 proposalId,
        address voter,
        Enums.VoteEntry voteEntry
    ) external;

    function unVoteProposal(uint256 proposalId, address voter) external;

    // STATE VIEWING FUNCTIONS

    function getProposal(
        uint256 proposalId
    ) external view returns (Models.Proposal memory);
}
