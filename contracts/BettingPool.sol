// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./PoolContract.sol";

contract BettingPool is PoolContract {
    IERC20 public bettingToken;

    struct Bet {
        address bettor;
        uint256 amount;
        uint256 outcomeId; // Identifier for the chosen outcome
    }

    struct Event {
        uint256 eventId;
        bool isResolved;
        uint256 winningOutcomeId;
        uint256 totalAmountBet;
    }

    mapping(uint256 => Event) public events; // EventId => Event
    mapping(uint256 => mapping(uint256 => Bet[])) public bets; // EventId => OutcomeId => Bets
    mapping(uint256 => mapping(address => uint256)) public winnings; // EventId => Bettor => Winnings

    event BetPlaced(uint256 indexed eventId, address indexed bettor, uint256 outcomeId, uint256 amount);
    event EventResolved(uint256 indexed eventId, uint256 winningOutcomeId);
    event WinningsClaimed(uint256 indexed eventId, address indexed bettor, uint256 amount);

    constructor(IERC20 _bettingToken) {
        bettingToken = _bettingToken;
    }

    function placeBet(uint256 eventId, uint256 outcomeId, uint256 amount) external override {
        require(amount > 0, "Cannot bet zero amount");
        bettingToken.transferFrom(msg.sender, address(this), amount);

        Event storage event = events[eventId];
        event.totalAmountBet += amount;

        bets[eventId][outcomeId].push(Bet({
            bettor: msg.sender,
            amount: amount,
            outcomeId: outcomeId
        }));

        emit BetPlaced(eventId, msg.sender, outcomeId, amount);
    }

    function resolveEvent(uint256 eventId, uint256 winningOutcomeId) external onlyOwner {
        Event storage event = events[eventId];
        event.isResolved = true;
        event.winningOutcomeId = winningOutcomeId;

        distributeWinnings(eventId, winningOutcomeId);

        emit EventResolved(eventId, winningOutcomeId);
    }

    function distributeWinnings(uint256 eventId, uint256 winningOutcomeId) internal {
        // Logic to calculate and distribute winnings to the winners
    }

    function claimWinnings(uint256 eventId) external {
        uint256 amount = winnings[eventId][msg.sender];
        require(amount > 0, "No winnings to claim");

        winnings[eventId][msg.sender] = 0;
        bettingToken.transfer(msg.sender, amount);

        emit WinningsClaimed(eventId, msg.sender, amount);
    }

    // Additional functions and overrides as required by PoolContract...
}
