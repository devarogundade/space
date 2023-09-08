// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "./../Plugin.sol";
import "./../libraries/PluginLib.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract SpaceVotingNFT is ERC721, Plugin {
    using Counters for Counters.Counter;

    address[] private _holders;

    string private _tokenURI;
    mapping(address => uint256[]) private _holderTokens;

    Counters.Counter private _tokenID;

    mapping(uint256 => mapping(address => uint256)) _lockeds;

    constructor(
        string memory name_,
        string memory symbol_,
        string memory pluginMetadata_,
        string memory tokenURI_,
        address[] memory holders_,
        uint256[] memory allocations_
    )
        ERC721(name_, symbol_)
        Plugin(PluginLib.MEMBERSHIP_CODE, pluginMetadata_)
    {
        for (uint256 index = 0; index < holders_.length; index++) {
            _mint(holders_[index], allocations_[index]);
            _holders.push(holders_[index]);
        }
        _tokenURI = tokenURI_;
    }

    function tokenURI(
        uint256 tokenId
    ) public view virtual override returns (string memory) {
        return _tokenURI;
    }

    function _transfer(
        address from,
        address to,
        uint256 tokenId
    ) internal override {
        for (uint256 index = 0; index < _holderTokens[from].length; index++) {
            if (_holderTokens[from][index] == tokenId) {
                delete _holderTokens[from][index];
                _holderTokens[to].push(tokenId);
            }
        }
        super._transfer(from, to, tokenId);
    }

    function addMember(address holder, uint256 allocation) external override {
        // EXPERIMENTAL
        // for (uint256 index = 0; index < allocation; index++) {
        //     _tokenID.increment();
        //     _mint(holder, _tokenID.current());
        //     _holders.push(holder);
        // }
        _tokenID.increment();
        _mint(holder, _tokenID.current());
        _holderTokens[holder].push(_tokenID.current());
        _holders.push(holder);
    }

    function removeMember(address holder) external override {}

    function charge(address from, uint256 amount, uint256 proposalId) external {
        uint256 tokenId = _holderTokens[from][0];
        _transfer(from, address(this), tokenId);
        _lockeds[proposalId][from] = tokenId;
    }

    function refund(uint256 proposalId) external override {
        for (uint256 index = 0; index < _holders.length; index++) {
            address holder = _holders[index];
            uint256 tokenId = _lockeds[proposalId][holder];
            _transfer(address(this), holder, tokenId);
            delete _lockeds[proposalId][holder];
        }
    }

    function holding(
        address holder,
        uint256 amount
    ) external view override returns (bool) {
        return balanceOf(holder) >= 1;
    }

    function members()
        external
        view
        override
        returns (address[] memory, uint256[] memory)
    {
        uint256[] memory _allocations = new uint256[](_holders.length);

        for (uint256 index = 0; index < _holders.length; index++) {
            _allocations[index] = _toWei(balanceOf(_holders[index]));
        }

        return (_holders, _allocations);
    }

    function _toWei(uint256 amount) private view returns (uint256) {
        return (amount * 10 ** 18);
    }

    // UNUSED METHODS
    function reward(address to, uint256 amount) external override {}
}
