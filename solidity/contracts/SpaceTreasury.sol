// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "./libraries/Models.sol";

import "./interfaces/ITreasury.sol";

import "@openzeppelin/contracts/access/Ownable2Step.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract SpaceTreasury is ITreasury, Ownable2Step {
    using Counters for Counters.Counter;

    uint256 private _balance;
    uint256 private _locked;

    Counters.Counter private _historyId;

    mapping(uint256 => Models.TreasureHistory) private _history;

    event TreasuryFunded(address dao, uint256 amount);
    event TreasurySpent(address dao, uint256 amount);

    constructor() Ownable2Step() {}

    function fundEVM(
        string memory summary
    ) external payable override returns (uint256) {
        _historyId.increment();
        uint256 historyId = _historyId.current();

        _history[historyId] = Models.TreasureHistory(
            msg.value,
            block.timestamp,
            summary,
            0, // direction
            msg.sender,
            address(this)
        );

        _balance += msg.value;

        emit TreasuryFunded(owner(), msg.value);

        return historyId;
    }

    function onExecute(
        string memory summary,
        uint256 amount,
        address receiver
    ) external override onlyOwner returns (uint256) {
        if (amount == 0) return 0;

        _historyId.increment();
        uint256 historyId = _historyId.current();

        require(_balance >= amount, "INSUFFICIENT_AMOUNT");

        _history[historyId] = Models.TreasureHistory(
            amount,
            block.timestamp,
            summary,
            1, // direction
            address(this),
            receiver
        );

        _balance -= amount;

        payable(receiver).transfer(amount);

        emit TreasurySpent(receiver, amount);

        return historyId;
    }

    function feed() external view returns (uint256, uint256) {
        return (_balance, _locked);
    }

    function getHistory(
        uint256 historyId
    ) external view returns (Models.TreasureHistory memory) {
        return _history[historyId];
    }

    function lastId() external view returns (uint256) {
        return _historyId.current();
    }
}
