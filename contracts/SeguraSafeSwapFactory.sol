// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "./AMMTradingPool.sol";
import "./StableCoinPool.sol";
import "./StandardTradingPool.sol";

contract SeguraSafeSwapFactory {

    address public sushiSwapRouter;

    constructor(address _sushiSwapRouter) {
        sushiSwapRouter = _sushiSwapRouter;
    }

    function createAMMTradingPool() external returns (address) {
        AMMTradingPool pool = new AMMTradingPool(sushiSwapRouter);
        return address(pool);
    }

    function createStandardTradingPool(uint256 tradingFee) external returns (address) {
        StandardTradingPool pool = new StandardTradingPool(tradingFee);
        return address(pool);
    }

    function createStableCoinPool(uint256 tradingFee) external returns (address) {
        StableCoinPool pool = new StableCoinPool(tradingFee);
        return address(pool);
    }

    // Add other functions to create different types of pools if necessary
}
