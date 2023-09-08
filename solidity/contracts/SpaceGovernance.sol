// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "./libraries/Enums.sol";
import "./libraries/Models.sol";

import "./interfaces/IGovernance.sol";

import "@openzeppelin/contracts/access/Ownable2Step.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract SpaceGovernance is Ownable2Step, IGovernance {
    using Counters for Counters.Counter;

    uint256 private constant ONE_DAY = 24 * 60 * 60;

    uint16 private _threshold = 50; // default
    uint256 private _minVoting = 1;
    uint256 private _minPropose = 1;
    uint64 private _minDuration = 5;
    bool private _earlyExecution;

    Counters.Counter private _proposalId;

    mapping(uint256 => Models.Proposal) private _proposals;
    mapping(uint256 => mapping(address => Enums.VoteEntry))
        private _voteEntries;

    constructor(
        uint16 threshold_,
        uint256 minVoting_,
        uint256 minPropose_,
        uint64 minDuration_,
        bool earlyExecution_
    ) Ownable2Step() {
        _threshold = threshold_;
        _minVoting = minVoting_;
        _minPropose = minPropose_;
        _minDuration = minDuration_;
        _earlyExecution = earlyExecution_;
    }

    event ProposalCreated(uint256 proposalId);
    event ProposalVoted(
        address voter,
        uint256 proposalId,
        Enums.VoteEntry voteEntry
    );
    event ProposalExecuted(uint256 proposalId);

    event ProposalUnVoted(address voter, uint256 proposalId);

    // STATE CHANGING FUNCTIONS

    function createProposal(
        Models.Proposal memory proposal
    ) external override onlyOwner returns (uint256 proposalId) {
        _proposalId.increment();
        proposalId = _proposalId.current();

        require(
            (proposal.endedOn - proposal.startedOn) >= (ONE_DAY * _minDuration),
            "VOTING_PERIOD_TOO_SHORT"
        );

        _proposals[proposalId] = proposal;

        emit ProposalCreated(proposalId);
    }

    function endProposal(uint256 proposalId) external override onlyOwner {
        Models.Proposal storage proposal = _proposals[proposalId];

        if (proposal.endedOn < block.timestamp) {
            proposal.endedOn = block.timestamp;
        }
    }

    function executeProposal(
        uint256 proposalId
    ) external override onlyOwner returns (uint256) {
        Models.Proposal storage proposal = _proposals[proposalId];

        require(proposal.executedOn == 0, "ALREADY_EXECUTED");

        (uint256 agree, uint256 disagree, uint256 abstain) = result(proposalId);
        uint256 totalVotes = (agree + disagree + abstain);

        if (!_earlyExecution) {
            require(proposal.endedOn < block.timestamp, "PROPOSAL_NOT_ENDED");
        }

        if (proposal.endedOn < block.timestamp) {
            proposal.endedOn = block.timestamp;
        }

        proposal.executedOn = block.timestamp;

        require(
            ((agree * 100) / totalVotes) >= _threshold,
            "THRESHOLD_NOT_MET"
        );

        emit ProposalExecuted(proposalId);

        return proposal.treasuryAmount;
    }

    function voteProposal(
        uint256 proposalId,
        address voter,
        Enums.VoteEntry voteEntry
    ) external override onlyOwner {
        Models.Proposal storage proposal = _proposals[proposalId];

        require(proposal.startedOn < block.timestamp, "VOTING_HAS_NOT_STARTED");
        require(proposal.endedOn > block.timestamp, "VOTING_HAS_ENDED");
        require(proposal.executedOn == 0, "PROPOSAL_HAS_BEEN_EXECUTED");

        for (uint256 index = 0; index < proposal.voters.length; index++) {
            if (proposal.voters[index] == voter) {
                revert("ALREADY_VOTED");
            }
        }

        _voteEntries[proposalId][voter] = voteEntry;
        proposal.voters.push(voter);

        emit ProposalVoted(voter, proposalId, voteEntry);
    }

    function unVoteProposal(
        uint256 proposalId,
        address voter
    ) external override onlyOwner {
        Models.Proposal storage proposal = _proposals[proposalId];

        delete _voteEntries[proposalId][voter];

        for (uint256 index = 0; index < proposal.voters.length; index++) {
            if (proposal.voters[index] == voter) {
                delete proposal.voters[index];
            }
        }

        emit ProposalUnVoted(voter, proposalId);
    }

    // STATE VIEWING FUNCTIONS

    function getProposal(
        uint256 proposalId
    ) external view override returns (Models.Proposal memory) {
        return _proposals[proposalId];
    }

    function threshold() external view returns (uint16) {
        return _threshold;
    }

    function minVoting() external view returns (uint256) {
        return _minVoting;
    }

    function minPropose() external view returns (uint256) {
        return _minPropose;
    }

    function minDuration() external view returns (uint64) {
        return _minDuration;
    }

    function earlyExecution() external view returns (bool) {
        return _earlyExecution;
    }

    function getVoteEntries(
        uint256 proposalId
    ) external view returns (address[] memory, Enums.VoteEntry[] memory) {
        address[] memory voters = _proposals[proposalId].voters;
        Enums.VoteEntry[] memory voteEntries = new Enums.VoteEntry[](
            voters.length
        );

        for (uint256 index = 0; index < voters.length; index++) {
            voteEntries[index] = _voteEntries[proposalId][voters[index]];
        }

        return (voters, voteEntries);
    }

    function result(
        uint256 proposalId
    ) public view returns (uint256 agree, uint256 disagree, uint256 abstain) {
        address[] memory voters = _proposals[proposalId].voters;

        for (uint256 index = 0; index < voters.length; index++) {
            address voter = voters[index];

            if (_voteEntries[proposalId][voter] == Enums.VoteEntry.Agree) {
                agree++;
            } else if (
                _voteEntries[proposalId][voter] == Enums.VoteEntry.Disagree
            ) {
                disagree++;
            } else {
                abstain++;
            }
        }
    }

    function lastId() external view returns (uint256) {
        return _proposalId.current();
    }
}
