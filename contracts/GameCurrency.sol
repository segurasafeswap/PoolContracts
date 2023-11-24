// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "./GamingERC1155NFT.sol";

contract GameCurrency is ERC20Upgradeable {
    address private gameOperator;

    function initialize(string memory name, string memory symbol, address _gameOperator) public initializer {
        __ERC20_init(name, symbol);
        gameOperator = _gameOperator;
    }

    modifier onlyGameOperator() {
        require(msg.sender == gameOperator, "Caller is not the game operator");
        _;
    }
    
    function awardTokens(address player, uint256 amount) public onlyGameOperator {
        _mint(player, amount);
    }

    GamingERC1155NFT public nftContract;

    function setNFTContractAddress(address _nftContractAddress) public onlyGameOperator {
    nftContract = GamingERC1155NFT(_nftContractAddress);
    }


    function completeQuest(address player, uint256 questId, uint256 tokensEarned, uint256 nftTokenId) public {
    // Verify quest completion and determine rewards...
    awardTokens(player, tokensEarned);
    nftContract.awardPlayer(player, nftTokenId, 1); // Assuming this is the correct method to award NFTs
    // Additional logic...
    }
}