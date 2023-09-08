// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "./../Plugin.sol";
import "./../libraries/PluginLib.sol";

contract SpaceVotingMultisig is Plugin {
    address[] private _signers;

    constructor(
        string memory pluginMetadata_,
        address[] memory signers_
    ) Plugin(PluginLib.MEMBERSHIP_CODE, pluginMetadata_) {
        _signers = signers_;
    }

    function holding(
        address holder,
        uint256 amount
    ) external view override returns (bool) {
        for (uint256 index = 0; index < _signers.length; index++) {
            if (_signers[index] == holder) {
                return true;
            }
        }
        return false;
    }

    function addMember(address holder, uint256 allocation) external override {
        _signers.push(holder);
    }

    function members()
        external
        view
        override
        returns (address[] memory, uint256[] memory)
    {
        uint256[] memory _allocations = new uint256[](0);
        return (_signers, _allocations);
    }

    // UNUSED METHODS
    function refund(uint256 proposalId) external override {}

    function removeMember(address holder) external override {}

    function charge(address from, uint256 amount, uint256 proposalId) external override {}

    function reward(address to, uint256 amount) external override {}
}
