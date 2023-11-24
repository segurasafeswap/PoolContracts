// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

interface IStandardPoolContract {
    // Events
    event OrderPlaced(uint256 indexed orderId, address indexed trader, bool isBuyOrder, uint256 tokenAmount, uint256 price);
    event OrderCancelled(uint256 indexed orderId);
    event TradeExecuted(uint256 indexed buyOrderId, uint256 indexed sellOrderId, uint256 tradedAmount, uint256 tradePrice);

    // Function to place a new order in the order book
    function placeOrder(
        address tokenIn, 
        address tokenOut, 
        uint256 amountIn, 
        uint256 price, 
        bool isBuyOrder
    ) external returns (uint256 orderId);

    // Function to cancel an existing order
    function cancelOrder(uint256 orderId) external;

    // Function to match orders
    function matchOrders() external;
}
