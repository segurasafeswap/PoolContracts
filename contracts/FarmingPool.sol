// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract FarmingPool is Ownable, ReentrancyGuard {
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
    event Staked(address indexed user, uint256 amount);
    event Withdrawn(address indexed user, uint256 amount);
    event RewardPaid(address indexed user, uint256 reward);

    modifier updateReward(address account) {
        rewardPerTokenStored = rewardPerToken();
        lastUpdateTime = block.timestamp;
        if (account != address(0)) {
            rewards[account] = earned(account);
            userRewardPerTokenPaid[account] = rewardPerTokenStored;
        }
        _;
    }

    modifier whenNotPaused() {
        require(!paused, "Contract is paused");
        _;
    }

    constructor(IERC20 _lpToken, IERC20 _rewardToken, uint256 _initialRewardRate) {
        lpToken = _lpToken;
        rewardToken = _rewardToken;
        rewardRate = _initialRewardRate;
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

    function stake(uint256 amount, bool isCompounding) public whenNotPaused updateReward(msg.sender) nonReentrant {
    require(amount > 0, "Cannot stake 0");

    if (isCompounding) {
        // Logic for compounding rewards
        require(rewards[msg.sender] >= amount, "Insufficient reward balance");
        rewards[msg.sender] -= amount; // Deducting the compounded amount from rewards
    } else {
        // Normal staking logic: Transfer from user's wallet
        lpToken.transferFrom(msg.sender, address(this), amount);
    }

    // Common logic for both compounding and normal staking
    // ... Update user's staked balance, etc. ...

    emit Staked(msg.sender, amount);
    }

    function withdraw(uint256 amount) public whenNotPaused updateReward(msg.sender) nonReentrant {
        require(amount > 0, "Cannot withdraw 0");
        lpToken.transfer(msg.sender, amount);
        emit Withdrawn(msg.sender, amount);
    }

    function claimReward() public updateReward(msg.sender) nonReentrant {
        uint256 reward = rewards[msg.sender];
        if (reward > 0) {
            rewards[msg.sender] = 0;
            rewardToken.transfer(msg.sender, reward);
            emit RewardPaid(msg.sender, reward);
        }
    }

    function rewardPerToken() public view returns (uint256) {
        if (lpToken.totalSupply() == 0) {
            return rewardPerTokenStored;
        }
        return rewardPerTokenStored + (((block.timestamp - lastUpdateTime) * rewardRate * 1e18) / lpToken.totalSupply());
    }

    function earned(address account) public view returns (uint256) {
        return ((lpToken.balanceOf(account) * (rewardPerToken() - userRewardPerTokenPaid[account])) / 1e18) + rewards[account];
    }

    function compound() public nonReentrant {
    uint256 reward = earned(msg.sender);
    if (reward > 0) {
        stake(reward, true);
    }
    }
}