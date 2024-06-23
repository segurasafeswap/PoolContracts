// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "./IPoolContract.sol";

/// @title Pool Contract
/// @notice Abstract contract for pool contract operations
abstract contract PoolContract is IPoolContract {
    uint256 public liquidity;

    // Define abstract functions for the derived contracts to implement
    function addLiquidity(uint256 amount) public virtual override;
    function removeLiquidity(uint256 amount) public virtual override;
    function swapTokens(address tokenIn, address tokenOut, uint256 amountIn) public virtual override returns (uint256 amountOut);
}
