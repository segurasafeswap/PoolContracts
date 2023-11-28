// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "./BaseERC721NFT.sol";

/// @title RealEstate ERC721 NFT 
/// @notice Concrete implementation of the realestate erc721 nft operations
contract RealEstateERC721NFT is BaseERC721NFT {
    struct Property {
        string location;
        uint256 area; // e.g., square feet or square meters
        string metadataURI; // Additional details about the property
        bool isRented; // Indicates if the property is currently rented
        address currentTenant; // Address of the current tenant, if any
    }

    mapping(uint256 => Property) public properties;

    constructor(string memory name, string memory symbol) BaseERC721NFT(name, symbol) {}

    function safeMintProperty(address to, uint256 tokenId, Property memory property) public onlyOwner {
        safeMint(to, tokenId);
        properties[tokenId] = property;
    }

    // Update property details
    function updateProperty(uint256 tokenId, Property memory newPropertyDetails) public onlyOwner {
        require(_exists(tokenId), "Property does not exist");
        properties[tokenId] = newPropertyDetails;
    }

    // Lease the property
    function leaseProperty(uint256 tokenId, address tenant, uint256 leaseDuration) public onlyOwner {
        require(_exists(tokenId), "Property does not exist");
        require(properties[tokenId].isRented == false, "Property already rented");
        properties[tokenId].isRented = true;
        properties[tokenId].currentTenant = tenant;
        // Logic to handle lease duration and terms
    }

    // End the lease
    function endLease(uint256 tokenId) public onlyOwner {
        require(_exists(tokenId), "Property does not exist");
        properties[tokenId].isRented = false;
        properties[tokenId].currentTenant = address(0);
        // Additional logic for lease termination
    }

    // Transfer the property
    function transferProperty(address from, address to, uint256 tokenId) public {
        require(_isApprovedOrOwner(_msgSender(), tokenId), "Not authorized");
        require(properties[tokenId].isRented == false, "Cannot transfer rented property");
        _transfer(from, to, tokenId);
    }

    // Property improvement
    function improveProperty(uint256 tokenId, string memory improvementDetails) public onlyOwner {
        require(_exists(tokenId), "Property does not exist");
        // Logic to record property improvement
    }

    // Handle utility management
    function manageUtilities(uint256 tokenId, string memory utilityDetails) public onlyOwner {
        require(_exists(tokenId), "Property does not exist");
        // Logic for utility management
    }

    // Override _exists to check if the property exists
    function _exists(uint256 tokenId) internal view override returns (bool) {
        return bytes(properties[tokenId].location).length > 0;
    }

    // Override necessary functions from ERC721 and BaseERC721NFT
    // Override _beforeTokenTransfer to handle additional logic, like rent status
    function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal override {
        super._beforeTokenTransfer(from, to, tokenId);
        require(properties[tokenId].isRented == false, "Cannot transfer rented property");
    }
}