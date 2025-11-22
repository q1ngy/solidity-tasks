// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

contract BinarySearch {
    function search(uint[] calldata nums, uint num) external pure returns (int) {
        uint left = 0;
        uint right = nums.length - 1;
        while (left <= right) {
            uint mid = (left + right) / 2;
            uint v = nums[mid];
            if (num == v) {
                return int(mid);
            } else if (num > v) {
                left = mid + 1;
            } else {
                right = mid - 1;
            }
        }
        return -1;
    }
}
