// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "./interfaces/IPlugin.sol";

abstract contract Plugin is IPlugin {

    string private _metadata;
    uint64 private immutable _accessCode;

    constructor(uint64 accessCode_, string memory metadata_) {
        _accessCode = accessCode_;
        _metadata = metadata_;
    }

    function accessCode() external view override returns (uint64) {
        return _accessCode;
    }

    function metadata() external view override returns (string memory) {
        return _metadata;
    }

}