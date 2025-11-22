// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract IntToRoman {
    function intToRoman(uint num) external pure returns (string memory res) {
        string[13] memory symbols = ["M", "CM", "D", "CD", "C", "XC", "L", "XL", "X", "IX", "V", "IV", "I"];
        uint[13] memory values = [uint(1000), 900, 500, 400, 100, 90, 50, 40, 10, 9, 5, 4, 1];
        for (uint i = 0; i < symbols.length; i++) {
            string memory s = symbols[i];
            uint v = values[i];
            while (num >= v) {
                num -= v;
                res = string.concat(res, s);
            }
        }
    }
}
