pragma solidity ^0.8.20;

contract MarginTradingContract {
    // ... existing contract code ...

    enum RiskLevel { Low, Medium, High }

    event MarginWarning(address indexed trader, uint256 marginHealth, RiskLevel riskLevel);

    // Function to calculate margin health and risk level
    function calculateMarginHealth(address trader) public view returns (uint256 health, RiskLevel level) {
        // Logic to calculate margin health (e.g., borrowed vs. collateral)
        // Return both the health percentage and the risk level
    }

    // Function to check margin health and emit warnings or liquidate
    function monitorMarginAccount(address trader) public {
        (uint256 health, RiskLevel level) = calculateMarginHealth(trader);

        if (health >= 97) {
            // Execute liquidation
        } else if (health >= 90) {
            // Emit warnings based on the health
            if (health >= 95) {
                emit MarginWarning(trader, health, RiskLevel.High);
            } else if (health >= 93) {
                emit MarginWarning(trader, health, RiskLevel.Medium);
            } else {
                emit MarginWarning(trader, health, RiskLevel.Low);
            }
        }
    }

    // ... additional functions ...
}