// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;


import "@openzeppelin/contracts/interfaces/IERC20.sol";


contract StakingPool {
    IERC20 public stakingToken;
    IERC20 public rewardToken;

    // Additional logic similar to FarmingContract...

    constructor(address _stakingToken, address _rewardToken) {
        stakingToken = IERC20(_stakingToken);
        rewardToken = IERC20(_rewardToken);
    }

    // Staking, withdrawal, and reward claiming functions...
}