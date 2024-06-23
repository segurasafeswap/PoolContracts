// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract FarmingPool is Ownable {
    // No arguments should be passed to the Ownable constructor

    constructor(IERC20 _lpToken, IERC20 _rewardToken, uint256 _initialRewardRate) {
    lpToken = _lpToken;
    rewardToken = _rewardToken;
    rewardRate = _initialRewardRate;
    // No call to the Ownable constructor needed as it requires no arguments
    }
     
    IERC20 public lpToken;
    IERC20 public rewardToken;

    uint256 public rewardRate;
    uint256 public lastUpdateTime;
    uint256 public rewardPerTokenStored;

    mapping(address => uint256) public userRewardPerTokenPaid;
    mapping(address => uint256) public rewards;

    bool public paused = false;
    event Paused(bool isPaused);
    event RewardUpdated(uint256 newRewardRate);

    modifier whenNotPaused() {
        require(!paused, "Contract is paused");
        _;
    }

    function pause() external onlyOwner {
        paused = true;
        emit Paused(true);
    }

    function unpause() external onlyOwner {
        paused = false;
        emit Paused(false);
    }

    function updateRewardRate(uint256 newRewardRate) external onlyOwner {
        rewardRate = newRewardRate;
        emit RewardUpdated(newRewardRate);
    }

    function stake(uint256 amount) public whenNotPaused {
         // ... existing stake logic ...
        userRewardPerTokenPaid[msg.sender] = rewardPerToken();
        rewards[msg.sender] = earned(msg.sender);
        // ... rest of the staking logic ...
    }

    function withdraw(uint256 amount) public whenNotPaused {
         // ... existing withdraw logic ...
        userRewardPerTokenPaid[msg.sender] = rewardPerToken();
        rewards[msg.sender] = earned(msg.sender);
        // ... rest of the withdrawal logic ...
    }

    function claimReward() public {
        uint256 reward = earned(msg.sender);
        if (reward > 0) {
            rewards[msg.sender] = 0;
            rewardToken.transfer(msg.sender, reward);
        }
    }

    function rewardPerToken() public view returns (uint256) {
        if (lpToken.totalSupply() == 0) {
            return rewardPerTokenStored;
        }
        return rewardPerTokenStored +
               (((block.timestamp - lastUpdateTime) * rewardRate * 1e18) / lpToken.totalSupply());
    }

    function earned(address account) public view returns (uint256) {
        return ((lpToken.balanceOf(account) * (rewardPerToken() - userRewardPerTokenPaid[account])) / 1e18) +
               rewards[account];
    }

    function compound() public {
        uint256 reward = earned(msg.sender);
        if (reward > 0) {
            rewards[msg.sender] = 0;
            stake(reward);
        }
    }
}