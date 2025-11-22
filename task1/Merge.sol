// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Merge {
    function merge(uint[] calldata nums1, uint[] calldata nums2) external pure returns (uint[] memory) {
        uint m = nums1.length;
        uint n = nums2.length;
        uint[] memory nums = new uint[](m + n);
        for (uint i = 0; i < m; i++) {
            nums[i] = nums1[i];
        }
        for (uint i = 0; i < n; i++) {
            nums[m + i] = nums2[i];
        }
        for (uint i = 0; i < m + n; i++) {
            for (uint j = 0; j < m + n - 1 - i; j++) {
                if (nums[j] > nums[j + 1]) {
                    uint t = nums[j];
                    nums[j] = nums[j + 1];
                    nums[j + 1] = t;
                }
            }
        }
        return nums;
    }
}
