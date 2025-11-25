// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

contract BeggingContract {
    address private immutable owner;
    mapping(address => uint) private donates;

    uint private immutable start;
    uint private immutable end;

    constructor() {
        owner = msg.sender;

        start = block.timestamp;
        end = start + 10 minutes;
    }

    event Donation(address indexed donator, uint amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "not owner");
        _;
    }

    function donate() external payable {
        require(block.timestamp >= start, "Not started yet");
        require(block.timestamp <= end, "Ended");

        require(msg.sender != address(0), "donator = address 0");
        require(msg.value > 0, "amount = 0");
        
        donates[msg.sender] += msg.value;

        emit Donation(msg.sender, msg.value);
    }

    function withdraw() external onlyOwner {
        payable(owner).transfer(address(this).balance);
    }

    function getDonation(address _donator) external view returns (uint) {
        return donates[_donator];
    }

}
