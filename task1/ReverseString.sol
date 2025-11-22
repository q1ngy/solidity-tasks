// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ReverseString {
    function reverseString(string memory s) external pure returns (string memory _s) {
        bytes memory b = bytes(s);
        for (uint i = 0; i < b.length / 2; i++) {
            bytes1 t = b[i];
            b[i] = b[b.length - i - 1];
            b[b.length - i - 1] = t;
        }
        _s = string(b);
    }
}
