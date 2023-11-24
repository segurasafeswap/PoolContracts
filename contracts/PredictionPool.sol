// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./PoolContract.sol";

contract PredictionPool is PoolContract {
    IERC20 public bettingToken;

    struct Bet {
        address better;
        uint256 amount;
        bool predictedOutcome;
    }

    mapping(uint256 => Bet[]) public bets; // Bets for each event

    event BetPlaced(address indexed better, uint256 indexed eventId, bool outcome, uint256 amount);
    event EventOutcomeSet(uint256 indexed eventId, bool outcome);
    event RewardsDistributed(uint256 indexed eventId);

    constructor(IERC20 _bettingToken) {
        bettingToken = _bettingToken;
    }

    function placeBet(uint256 eventId, bool predictedOutcome, uint256 amount) external override {
        require(amount > 0, "Amount must be greater than 0");
        // Transfer betting tokens to this contract
        bettingToken.transferFrom(msg.sender, address(this), amount);

        // Record the bet details
        bets[eventId].push(Bet(msg.sender, amount, predictedOutcome));
        emit BetPlaced(msg.sender, eventId, predictedOutcome, amount);
    }

    function cancelBet(uint256 eventId, uint256 betIndex) external override {
        // Logic to allow a user to cancel their bet, if applicable
    }

    function setEventOutcome(uint256 eventId, bool outcome) external onlyOwner {
        // Set the outcome of an event (to be called by the oracle or manually by the owner)
        emit EventOutcomeSet(eventId, outcome);
    }

    function distributeRewards(uint256 eventId) external override {
        // Distribute rewards based on the outcome and the bets
        emit RewardsDistributed(eventId);
    }

    // Implement any additional abstract methods from PoolContract
    // ...
}
