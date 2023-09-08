// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "./Space.sol";

import "./interfaces/IPluginManager.sol";
import "./interfaces/IPluginManager2.sol";

import "@openzeppelin/contracts/utils/Context.sol";

/**
 * V1.0 Space Factory - For PEGO Hackathon
 * Author: Arogundade Ibrahim
 */
contract SpaceFactory is Context {
    uint16 public constant VERSION = 1;

    address[] private _daos;

    IPluginManager private _pluginManager;
    IPluginManager2 private _pluginManager2;

    mapping(address => address[]) private _privateDaos;
    mapping(string => address) private _subdomains;

    event DAOCreated(string metadata, address dao, address owner);

    constructor(address pluginManager_, address pluginManager2_) {
        _pluginManager = IPluginManager(pluginManager_);
        _pluginManager2 = IPluginManager2(pluginManager2_);
    }

    function deployDAO(
        string memory metadata,
        string memory subdomain,
        uint16 threshold,
        uint8 membership,
        uint8 incentives,
        string memory tokenName,
        string memory tokenSymbol,
        address[] memory holders,
        uint256[] memory allocations,
        string memory tokenURI,
        string memory rewardURI,
        uint256 minVoting,
        uint256 minPropose,
        uint64 minDuration,
        bool earlyExecution,
        address parentDao
    ) external {
        address[] memory plugins = new address[](2);

        address plugin0 = _pluginManager.create(
            membership,
            incentives,
            tokenName,
            tokenSymbol,
            holders,
            allocations,
            tokenURI
        );

        address plugin1 = _pluginManager2.create(
            incentives,
            tokenName,
            tokenSymbol,
            rewardURI
        );

        plugins[0] = plugin0;
        plugins[1] = plugin1;

        Space dao = new Space(
            metadata,
            _msgSender(),
            threshold,
            minVoting,
            minPropose,
            minDuration,
            earlyExecution,
            plugins,
            parentDao
        );

        require(
            _subdomains[subdomain] == address(0),
            "SUBDOMAIN_NOT_AVAILABLE"
        );

        _privateDaos[_msgSender()].push(address(dao));
        _subdomains[subdomain] = address(dao);

        _daos.push(address(dao));

        emit DAOCreated(metadata, address(dao), _msgSender());
    }

    function availability(
        string memory subdomain
    ) external view returns (bool) {
        return _subdomains[subdomain] == address(0);
    }

    function daos() external view returns (string[] memory) {
        string[] memory data = new string[](_daos.length);

        for (uint256 index = 0; index < _daos.length; index++) {
            Space dao = Space(_daos[index]);
            data[index] = dao.metadata();
        }

        return data;
    }

    function resolveName(
        string memory subdomain
    ) external view returns (address) {
        return _subdomains[subdomain];
    }

    function daosOf(address owner) external view returns (address[] memory) {
        return _privateDaos[owner];
    }
}
