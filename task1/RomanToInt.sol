// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract RomanToInt {
    mapping(bytes1 => uint) private m;
    constructor() {
        m["I"] = 1;
        m["V"] = 5;
        m["X"] = 10;
        m["L"] = 50;
        m["C"] = 100;
        m["D"] = 500;
        m["M"] = 1000;
    }

    function romanToInt(string memory s) external view returns (int res) {
        bytes memory b = bytes(s);
        for (uint i = 0; i < b.length; i++) {
            uint value = m[b[i]];
            if (i < b.length - 1 && value < m[b[i + 1]]) {
                res -= int(value);
            } else {
                res += int(value);
            }
        }
    }
}
