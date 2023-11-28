// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

abstract contract BaseERC721NFT is Initializable, ERC721Upgradeable, OwnableUpgradeable {
    function initializeBaseERC721(string memory name, string memory symbol, address initialOwner) internal initializer {
        __ERC721_init(name, symbol);
        __Ownable_init(initialOwner);
    }

    function safeMint(address to, uint256 tokenId) public virtual onlyOwner {
        _safeMint(to, tokenId);
    }

    function _exists(uint256 tokenId) internal view returns (bool) {
        try this.ownerOf(tokenId) returns (address) {
            return true;
        } catch {
            return false;
        }
    }

    // Additional functions and logic...
}