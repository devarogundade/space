// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "./Enums.sol";

library Models {

    struct Proposal {
        string metadata;
        uint256 createdOn;
        uint256 startedOn;
        uint256 endedOn;
        uint256 executedOn;
        address creator;
        address[] voters;
        uint256 treasuryAmount;
        string treasurySummary;
    }

    struct TreasureHistory {
        uint256 amount;
        uint256 timestamp;
        string summary;
        uint256 direction;
        address from;
        address to;
    }

}