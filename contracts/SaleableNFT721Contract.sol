// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";

/// @title Saleable NFT 721 Contract
/// @notice Abstract contract for saleable nft 721 contract operations
contract SaleableNFT721Contract {
    // ... other contract code ...

    // Mapping from token ID to its sale price
    mapping(uint256 => uint256) public nftSalePrice;

    // ERC1155 does not keep track of individual owners as ERC721,
    // so if needed, you'll have to implement it depending on your use case
    mapping(uint256 => address) private nftOwners;

    uint256 public platformFeePercent; // e.g., 5 for 5%
    address payable public platformWallet;

    constructor(uint256 _platformFeePercent, address payable _platformWallet) {
        platformFeePercent = _platformFeePercent;
        platformWallet = _platformWallet;
        // ... other constructor code ...
    }

    function buyNFT(uint256 tokenId) public payable {
        uint256 salePrice = nftSalePrice[tokenId];
        require(msg.value >= salePrice, "Insufficient payment");

        uint256 platformFee = (salePrice * platformFeePercent) / 100;
        uint256 sellerAmount = salePrice - platformFee;

        address seller = nftOwners[tokenId]; // Ensure this is correctly managed

        // Transfer platform fee
        platformWallet.transfer(platformFee);

        // Transfer remaining funds to the seller
        payable(seller).transfer(sellerAmount);

        // Use safeTransferFrom to transfer the NFT ownership
        safeTransferFrom(seller, msg.sender, tokenId, 1, ""); // Assuming one copy of tokenId is being transferred

        // Update the owner mapping
        nftOwners[tokenId] = msg.sender;

        // Emit an event or handle other post-sale logic
    }

    function _updateOwner(uint256 tokenId, address newOwner) internal {
        nftOwners[tokenId] = newOwner;
    }

    // Override safeTransferFrom to update the owner mapping
    function safeTransferFrom(
        address from,
        address to,
        uint256 id,
        uint256 amount,
        bytes memory data
    )
        public
        override
    {
        require(amount == 1, "Can only transfer one at a time"); // Ensure only one NFT is transferred
        super.safeTransferFrom(from, to, id, amount, data);
        _updateOwner(id, to);
    }

    // ... other contract code ...
}