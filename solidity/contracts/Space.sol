// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "./libraries/Enums.sol";
import "./libraries/Models.sol";
import "./libraries/PluginLib.sol";

import "./interfaces/IPlugin.sol";
import "./interfaces/ISpace.sol";

import "./SpaceTreasury.sol";
import "./SpaceGovernance.sol";
import "./SpaceMembership.sol";
import "./SpaceIncentives.sol";

import "@openzeppelin/contracts/utils/Context.sol";

/**
 * V1.0 Space DAO - For PEGO Hackathon
 * Author: Arogundade Ibrahim
 */
contract Space is ISpace, Context {
    // dao properties
    address private _owner;
    string private _metadata;
    uint256 private _createdOn;
    bool private _paused;
    address private _parentDao;

    // maps plugin access code to plugin contract address
    mapping(uint64 => address) private _plugins;

    // dao features contracts
    SpaceTreasury private _treasury;
    SpaceGovernance private _governance;
    SpaceMembership private _membership;
    SpaceIncentives private _incentives;

    constructor(
        string memory metadata_,
        address owner_,
        uint16 threshold_,
        uint256 minVoting_,
        uint256 minPropose_,
        uint64 minDuration_,
        bool earlyExecution_,
        address[] memory plugins_,
        address parentDao_
    ) {
        _owner = owner_;
        _metadata = metadata_;
        _createdOn = block.timestamp;
        _paused = false;
        _parentDao = parentDao_;

        // register the plugins
        for (uint256 index = 0; index < plugins_.length; index++) {
            _registerPlugin(plugins_[index]);
        }

        _treasury = new SpaceTreasury();

        _governance = new SpaceGovernance(
            threshold_,
            minVoting_,
            minPropose_,
            minDuration_,
            earlyExecution_
        );

        _membership = new SpaceMembership();

        _incentives = new SpaceIncentives();
    }

    function createProposal(
        string memory metadata_,
        uint256 startedOn_,
        uint256 endedOn_,
        uint256 treasuryAmount_,
        string memory treasurySummary_
    ) external whenNotPaused {
        Models.Proposal memory proposal = Models.Proposal({
            metadata: metadata_,
            createdOn: block.timestamp,
            startedOn: startedOn_,
            endedOn: endedOn_,
            creator: _msgSender(),
            treasuryAmount: treasuryAmount_,
            treasurySummary: treasurySummary_,
            voters: new address[](0),
            executedOn: 0
        });

        _governance.createProposal(proposal);

        (bool perm, address plugin) = getPlugin(PluginLib.MEMBERSHIP_CODE);
        if (perm) {
            _membership.beforeAction(
                _msgSender(),
                _governance.minPropose(),
                forcePlugin(PluginLib.MEMBERSHIP_CODE)
            );
        }

        (bool perm1, address plugin1) = getPlugin(PluginLib.INCENTIVES_CODE);
        if (perm1) {
            _incentives.onProposed(_msgSender(), 1, plugin1);
        }
    }

    function voteProposal(
        uint256 proposalId,
        Enums.VoteEntry voteEntry,
        uint256 amount
    ) external whenNotPaused {
        _governance.voteProposal(proposalId, _msgSender(), voteEntry);

        (bool perm, address plugin) = getPlugin(PluginLib.MEMBERSHIP_CODE);
        if (perm) {
            require(
                amount >= _governance.minVoting(),
                "INSUFFICIENT_VOTING_POWER"
            );
            _membership.beforeAction(
                _msgSender(),
                amount,
                forcePlugin(PluginLib.MEMBERSHIP_CODE)
            );
            _membership.onVoted(_msgSender(), amount, proposalId, plugin);
        }

        (bool perm1, address plugin1) = getPlugin(PluginLib.INCENTIVES_CODE);
        if (perm1) {
            _incentives.onVoted(_msgSender(), 1, plugin1);
        }
    }

    function executeProposal(
        uint256 proposalId,
        string memory summary
    ) external onlyOwner {
        uint256 amount = _governance.executeProposal(proposalId);

        (bool perm, address plugin) = getPlugin(PluginLib.MEMBERSHIP_CODE);
        if (perm) {
            _membership.distribute(proposalId, plugin);
        }

        _treasury.onExecute(summary, amount, _owner);
    }

    function registerPlugin(
        address plugin_
    ) public onlyOwner whenNotPaused returns (bool) {
        return _registerPlugin(plugin_);
    }

    function _registerPlugin(
        address plugin_
    ) private whenNotPaused returns (bool) {
        if (plugin_ == address(0)) return false;

        IPlugin plugin = IPlugin(plugin_);
        uint64 accessCode = plugin.accessCode();

        if (_plugins[accessCode] == address(0)) {
            _plugins[accessCode] = plugin_;
            return true;
        }

        revert("UNREGISTER_PLUGIN_FIRST");
    }

    function unRegisterPlugin(
        uint64 accessCode
    ) external onlyOwner whenNotPaused returns (bool) {
        if (_plugins[accessCode] != address(0)) {
            _plugins[accessCode] = address(0);
            return true;
        }

        return false;
    }

    function pause() external onlyOwner {
        _paused = true;
    }

    function upPause() external onlyOwner {
        _paused = false;
    }

    function getPlugin(uint64 accessCode) public view returns (bool, address) {
        return (_plugins[accessCode] != address(0), _plugins[accessCode]);
    }

    function forcePlugin(uint64 accessCode) public view returns (address) {
        return _plugins[accessCode];
    }

    function metadata() external view returns (string memory) {
        return _metadata;
    }

    function childOf() external view override returns (address) {
        return _parentDao;
    }

    function transferTo(address newOwner) external override onlyOwner {
        _owner = newOwner;
    }

    function dao()
        external
        view
        returns (
            string memory,
            address,
            address,
            address,
            address,
            address,
            uint256,
            bool,
            address
        )
    {
        return (
            _metadata,
            _owner,
            address(_treasury),
            address(_governance),
            address(_incentives),
            address(_membership),
            _createdOn,
            _paused,
            _parentDao
        );
    }

    modifier onlyOwner() {
        require(_msgSender() == _owner);
        _;
    }

    modifier whenNotPaused() {
        require(_paused == false, "DAO_IS_PAUSED");
        _;
    }
}
