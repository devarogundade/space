// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

interface ITreasury {
    function fundEVM(
        string memory summary
    ) external payable returns (uint256 historyId);

    function onExecute(
        string memory summary,
        uint256 amount,
        address receiver
    ) external returns (uint256 historyId);
}
