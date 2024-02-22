// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;
import {ERC721Enumerable} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Ownable2Step} from "@openzeppelin/contracts/access/Ownable2Step.sol";
import {NFT} from "./NFT.sol";

/// @title PrimeNFTFilter
/// @author zeng
/// @dev Filter the tokenId that is prime number and return total prime count owned by an address
contract PrimeNFTFilter {
    NFT nfttoken;

    constructor(address nft_) {
        nfttoken = NFT(nft_);
    }

    /// @notice find the prime count of an address
    /// @param owner the address to find
    /// @return total amount of token Id owned by owner that is prime number
    function findPrimeCount(address owner) public view returns (uint256) {
        uint256 totalBalance = nfttoken.balanceOf(owner);
        uint256 primeCount;
        for (uint256 i = 0; i < totalBalance; i++) {
            bool result = isPrime(nfttoken.tokenOfOwnerByIndex(owner, i));
            if (result) {
                primeCount += 1;
            }
        }
        return primeCount;
    }

    /// @notice find prime number
    /// @param tokenId check whether if tokenId is prime
    /// @return true if tokenId is prime, else return false
    function isPrime(uint256 tokenId) internal pure returns (bool) {
        if (tokenId <= 1) return false;
        for (uint256 i = 2; i * i <= tokenId; i++) {
            if (tokenId % i == 0) return false;
        }
        return true;
    }
}
