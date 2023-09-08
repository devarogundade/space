// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "./../Plugin.sol";
import "./../libraries/PluginLib.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract SpaceRewardNFT is ERC721, Plugin {
    using Counters for Counters.Counter;
    string private _tokenURI;

    Counters.Counter private _tokenID;

    constructor(
        string memory name_,
        string memory symbol_,
        string memory pluginMetadata_,
        string memory rewardURI_
    )
        ERC721(name_, symbol_)
        Plugin(PluginLib.INCENTIVES_CODE, pluginMetadata_)
    {
        _tokenURI = rewardURI_;
    }

    function tokenURI(
        uint256 tokenId
    ) public view virtual override returns (string memory) {
        return _tokenURI;
    }

    function reward(address to, uint256 amount) external override {
        for (uint256 index = 0; index < amount; index++) {
            _tokenID.increment();
            _mint(to, _tokenID.current());
        }
    }

    function addMember(address holder, uint256 allocation) external override {
        for (uint256 index = 0; index < allocation; index++) {
            _tokenID.increment();
            _mint(holder, _tokenID.current());
        }
    }

    // UNUSED METHODS
    function removeMember(address holder) external override {}

    function charge(
        address from,
        uint256 amount,
        uint256 proposalId
    ) external override {}

    function refund(uint256 proposalId) external override {}

    function holding(
        address holder,
        uint256 amount
    ) external view override returns (bool) {
        return false;
    }

    function members()
        external
        view
        override
        returns (address[] memory, uint256[] memory)
    {
        address[] memory _holders = new address[](_tokenID.current());

        for (uint256 index = 1; index <= _tokenID.current(); index++) {
            _holders[index - 1] = ownerOf(index);
        }

        return (_holders, new uint256[](0));
    }
}
