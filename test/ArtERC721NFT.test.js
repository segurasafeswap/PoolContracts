const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("ArtERC721NFT Contract Tests", function () {

    it("Should deploy the contract", async function () {
        const ArtERC721NFT = await ethers.getContractFactory("ArtERC721NFT");
        const artERC721NFT = await ArtERC721NFT.deploy();
        await artERC721NFT.deployed();
    
    // Mint a new artwork
    await artNFT.safeMintWithRoyalty(accounts[0], tokenId, /* other parameters */);

    // Update provenance
    await artNFT.updateProvenance(tokenId, newProvenance);

    // Fetch the artwork details
    const artwork = await artNFT.artworks(tokenId);

    // Assert that the provenance was updated
    assert.equal(artwork.provenance, newProvenance, "Provenance did not update correctly");
  });
});