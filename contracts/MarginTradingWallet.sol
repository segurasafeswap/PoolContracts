// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";


contract MarginTradingWallet is ReentrancyGuard {
    AggregatorV3Interface internal priceFeed;
    IERC20 public collateralToken;
    uint256 public collateralFactor;

    mapping(address => uint256) public collateralBalances;
    mapping(address => uint256) public debtBalances;

    // Additional data structure to store position details
    struct Position {
        uint256 size;
        uint256 leverage;
        bool isLong;
        uint256 openPrice;
        // ... other fields ...
    }

    mapping(address => Position[]) public positions;

    event CollateralDeposited(address indexed user, uint256 amount);
    event CollateralWithdrawn(address indexed user, uint256 amount);
    event LeveragedPositionOpened(address indexed user, uint256 amount, uint256 leverage, bool isLong);
    event CollateralSold(address indexed trader, uint256 collateralAmount, uint256 receivedFunds);
    event BalancesUpdatedPostLiquidation(address indexed trader, uint256 collateralSold, uint256 debtReduced);

    constructor(address _priceFeed, address _collateralToken, uint256 _collateralFactor) {
        priceFeed = AggregatorV3Interface(_priceFeed);
        collateralToken = IERC20(_collateralToken);
        collateralFactor = _collateralFactor;
    }

    function getCollateralValue(address trader) public view returns (uint256) {
        // Implement the logic to calculate the collateral value
        // Example: Simply returning the balance; adjust as needed for your logic
        return collateralBalances[trader];
    }

    function getDebtValue(address trader) public view returns (uint256) {
        // Return the debt value for the trader
        return debtBalances[trader];
    }

    function depositCollateral(uint256 amount) external nonReentrant {
        require(amount > 0, "Amount must be greater than 0");
        collateralToken.transferFrom(msg.sender, address(this), amount);
        collateralBalances[msg.sender] += amount;
        emit CollateralDeposited(msg.sender, amount);
    }

    function withdrawCollateral(uint256 amount) external nonReentrant {
        require(amount > 0, "Amount must be greater than 0");
        require(debtBalances[msg.sender] == 0, "Cannot withdraw collateral while loan is active");
        require(collateralBalances[msg.sender] >= amount, "Insufficient collateral balance");

        collateralBalances[msg.sender] -= amount;
        collateralToken.transfer(msg.sender, amount);
        emit CollateralWithdrawn(msg.sender, amount);
    }

    function openLeveragedPosition(uint256 amount, uint256 leverage, bool isLong) external nonReentrant {
        require(amount > 0, "Amount must be greater than 0");
        require(leverage > 0, "Leverage must be greater than 0");
        
        uint256 positionValue = amount * leverage;
        uint256 requiredCollateral = positionValue * collateralFactor / 100;
        require(collateralBalances[msg.sender] >= requiredCollateral, "Insufficient collateral");

        debtBalances[msg.sender] += positionValue - amount;
        collateralBalances[msg.sender] -= requiredCollateral; // Lock the required collateral
        positions[msg.sender].push(Position(amount, leverage, isLong, getCurrentPrice()));

        emit LeveragedPositionOpened(msg.sender, amount, leverage, isLong);
    }

    function getCurrentPrice() internal view returns (uint256) {
    (
        /* uint80 roundID */,
        int256 price,
        /* uint256 startedAt */,
        /* uint256 timeStamp */,
        /* uint80 answeredInRound */
    ) = priceFeed.latestRoundData();
    require(price > 0, "Invalid price data");
    return uint256(price);
    }

    function sellCollateral(address trader, uint256 collateralAmount) public {
        // Check if the trader has enough collateral
        require(collateralBalances[trader] >= collateralAmount, "Insufficient collateral");

        // Step 1: Interact with a DEX to sell the collateral
        // This is highly simplified. In practice, you'd need to interact with the DEX contract
        // Here, we'll just assume the collateral is sold for its nominal value in debt currency
        uint256 receivedFunds = collateralAmount; // Simplified assumption

        // Step 2: Update the trader's debt and collateral balances
        collateralBalances[trader] -= collateralAmount;
        debtBalances[trader] -= receivedFunds;

        // Ensure debt doesn't go negative
        if (debtBalances[trader] < 0) {
            debtBalances[trader] = 0;
        }

        // Step 3: Emit an event (if applicable)
        emit CollateralSold(trader, collateralAmount, receivedFunds);
    }

    function updateBalancesPostLiquidation(address trader, uint256 collateralSold, uint256 debtReduced) public {
        // Ensure the function is called by an authorized contract, like MarginTradingContract
        // You might want to include a modifier for access control

        // Update the collateral balance
        require(collateralBalances[trader] >= collateralSold, "Collateral balance too low");
        collateralBalances[trader] -= collateralSold;

        // Update the debt balance
        require(debtBalances[trader] >= debtReduced, "Debt balance too low");
        debtBalances[trader] -= debtReduced;

        // Emit an event if necessary
        emit BalancesUpdatedPostLiquidation(trader, collateralSold, debtReduced);
    }
    // ... additional functions for trading, liquidation, etc. ...
}