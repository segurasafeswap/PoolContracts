// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IPoolContract {
    function addLiquidity(uint256 amount) external;
    function removeLiquidity(uint256 amount) external;
    function swapTokens(address tokenIn, address tokenOut, uint256 amountIn) external returns (uint256 amountOut);
}
