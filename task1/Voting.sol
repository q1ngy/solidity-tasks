// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Voting {
    mapping(address => uint) private votes;

    function vote(address candidate) external {
        votes[candidate]++;
    }

    function getVotes(address candidate) external view returns (uint) {
        return votes[candidate];
    }

    function resetVotes(address candidate) external {
        votes[candidate] = 0;
    }
}
