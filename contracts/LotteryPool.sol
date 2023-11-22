// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./PoolContract.sol";

contract LotteryPool is PoolContract, Ownable {
    IERC20 public lotteryToken;
    uint256 public ticketPrice;
    uint256 public lotteryEndTime;
    address[] public participants;

    event TicketPurchased(address indexed participant);
    event LotteryEnded(address indexed winner, uint256 prizeAmount);

    constructor(IERC20 _lotteryToken, uint256 _ticketPrice, uint256 _lotteryDuration) {
        lotteryToken = _lotteryToken;
        ticketPrice = _ticketPrice;
        lotteryEndTime = block.timestamp + _lotteryDuration;
    }

    function buyTicket() external {
        require(block.timestamp < lotteryEndTime, "Lottery has ended");
        lotteryToken.transferFrom(msg.sender, address(this), ticketPrice);
        participants.push(msg.sender);
        emit TicketPurchased(msg.sender);
    }

    function endLottery() external onlyOwner {
        require(block.timestamp >= lotteryEndTime, "Lottery is still active");
        require(participants.length > 0, "No participants");

        uint256 winnerIndex = random() % participants.length;
        address winner = participants[winnerIndex];
        uint256 prizeAmount = lotteryToken.balanceOf(address(this));
        
        lotteryToken.transfer(winner, prizeAmount);
        emit LotteryEnded(winner, prizeAmount);

        // Reset for the next round
        delete participants;
        lotteryEndTime = block.timestamp + 3600; // Example: Resetting for another hour
    }

    function random() private view returns (uint256) {
        return uint256(keccak256(abi.encodePacked(block.difficulty, block.timestamp, participants)));
    }

    // Additional functions and overrides as required by PoolContract...
}
