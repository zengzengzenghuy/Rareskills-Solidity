// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;
import {ERC721Enumerable} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Ownable2Step} from "@openzeppelin/contracts/access/Ownable2Step.sol";
import {NFTToken} from "./NFTToken.sol";

contract PrimeNFTFilter {
    NFTToken nfttoken;

    constructor(address nft_) {
        nfttoken = NFTToken(nft_);
    }

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

    function isPrime(uint256 tokenId) internal pure returns (bool) {
        if (tokenId <= 1) return false;
        for (uint256 i = 2; i * i <= tokenId; i++) {
            if (tokenId % i == 0) return false;
        }
        return true;
    }
}
