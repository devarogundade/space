// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

interface ISpace {

    function transferTo(address newOwner) external;

    function childOf() external returns (address);

}