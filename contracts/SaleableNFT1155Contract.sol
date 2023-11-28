// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";

/// @title Saleable NFT 1155 Contract
/// @notice Abstract contract for saleable nft 1155 contract operations
abstract contract SaleableNFT1155Contract is ERC1155, Ownable {
    // ... other contract code ...

    // Events
    event SalePriceSet(uint256 indexed tokenId, uint256 salePrice);
    event SaleStatusChanged(uint256 indexed tokenId, bool isForSale);
    event NFTSold(address indexed buyer, uint256 indexed tokenId, uint256 amount, uint256 totalPrice);

    // Mapping from token ID to its sale price
    mapping(uint256 => uint256) public nftSalePrice;

    // Track Available Copies for Each Token ID
    mapping(uint256 => uint256) public availableCopies;

    // Mapping to track if a token ID is available for sale
    mapping(uint256 => bool) public isTokenForSale;

    uint256 public platformFeePercent; // e.g., 5 for 5%
    address payable public platformWallet;

    constructor(uint256 _platformFeePercent, address payable _platformWallet) {
        platformFeePercent = _platformFeePercent;
        platformWallet = _platformWallet;
        // ... other constructor code ...
    }

    struct BatchSaleItem {
    uint256 tokenId;
    uint256 amount;
    uint256 salePricePerToken;
    }

    // Function to set the sale price of a specific token ID
    function setSalePrice(uint256 tokenId, uint256 salePrice) public onlyOwner {
        require(salePrice > 0, "Sale price must be greater than zero");
        
        nftSalePrice[tokenId] = salePrice;

        // Optionally, automatically mark the item as available for sale
        isTokenForSale[tokenId] = true;

        emit SalePriceSet(tokenId, salePrice);
        emit SaleStatusChanged(tokenId, true);
    }

    // Function to change the sale status of a token
    function setSaleStatus(uint256 tokenId, bool forSale) public onlyOwner {
        isTokenForSale[tokenId] = forSale;
        emit SaleStatusChanged(tokenId, forSale);
    }

    function buyBatchNFT(BatchSaleItem[] memory items) public payable {
    uint256 totalCost = 0;
    for (uint256 i = 0; i < items.length; i++) {
        BatchSaleItem memory item = items[i];
        require(isTokenForSale[item.tokenId], "Token not for sale");
        require(availableCopies[item.tokenId] >= item.amount, "Not enough copies available");
        totalCost += item.salePricePerToken * item.amount;
    }

    require(msg.value >= totalCost, "Insufficient payment");

    // Loop again to process each item
    for (uint256 i = 0; i < items.length; i++) {
        BatchSaleItem memory item = items[i];

        // Deduct the available copies
        availableCopies[item.tokenId] -= item.amount;

        // Transfer the NFTs
        _safeTransferFrom(address(this), msg.sender, item.tokenId, item.amount, "");
    }

    // Handle the payment at the end
    handlePayment(totalCost);

    // Emit events or handle other post-sale logic...
    }

    function handlePayment(uint256 totalSalePrice) private {
    uint256 platformFee = (totalSalePrice * platformFeePercent) / 100;

    // Transfer platform fee
    platformWallet.transfer(platformFee);

    // If the contract is the seller, the remaining funds (sellerAmount) can be kept in the contract
    // or handled according to your business logic.
    }
}