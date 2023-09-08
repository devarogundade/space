// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "./../Plugin.sol";
import "./../libraries/PluginLib.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract SpaceVotingToken is ERC20, Plugin {
    address[] private _holders;
    mapping(uint256 => mapping(address => uint256)) _lockeds;

    constructor(
        string memory name_,
        string memory symbol_,
        string memory pluginMetadata_,
        address[] memory holders_,
        uint256[] memory allocations_
    ) ERC20(name_, symbol_) Plugin(PluginLib.MEMBERSHIP_CODE, pluginMetadata_) {
        for (uint256 index = 0; index < holders_.length; index++) {
            _mint(holders_[index], allocations_[index]);
            _holders.push(holders_[index]);
        }
    }

    function addMember(address holder, uint256 allocation) external override {
        _mint(holder, allocation);
        _holders.push(holder);
    }

    function removeMember(address holder) external override {
        _burn(holder, balanceOf(holder));
    }

    function charge(
        address from,
        uint256 amount,
        uint256 proposalId
    ) external override {
        _transfer(from, address(this), amount);
        _lockeds[proposalId][from] = amount;
    }

    function refund(uint256 proposalId) external override {
        for (uint256 index = 0; index < _holders.length; index++) {
            address holder = _holders[index];
            uint256 amount = _lockeds[proposalId][holder];
            _transfer(address(this), holder, amount);
            delete _lockeds[proposalId][holder];
        }
    }

    function holding(
        address holder,
        uint256 amount
    ) external view returns (bool) {
        return balanceOf(holder) >= amount;
    }

    function members()
        external
        view
        override
        returns (address[] memory, uint256[] memory)
    {
        uint256[] memory _allocations = new uint256[](_holders.length);

        for (uint256 index = 0; index < _holders.length; index++) {
            _allocations[index] = balanceOf(_holders[index]);
        }

        return (_holders, _allocations);
    }

    // UNUSED METHODS
    function reward(address to, uint256 amount) external override {}
}
