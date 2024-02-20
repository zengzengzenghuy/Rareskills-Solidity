// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;
import "forge-std/Test.sol";

import {PrimeNFTFilter} from "../src/PrimeNFTFilter.sol";
import {NFT} from "../src/NFT.sol";

contract PrimeNFTFilterTest is Test{
    NFT nft;
    PrimeNFTFilter primeNFTFilter;

    address alice;
    uint256[] tokenIds;
    function setUp() public {
        nft = new NFT("NFT","NFT");
        primeNFTFilter = new PrimeNFTFilter(address(nft));

        alice = makeAddr("alice");
        tokenIds = new uint256[](20);
        for(uint256 i =0; i<20; i++){
            tokenIds[i] = i*5 + uint256(keccak256(abi.encodePacked(i*i + block.timestamp))) % 5;
        }
        // tokenIds = [3,7,10,16,22,29,31,35,40,48,50,58,61,67,72,78,80,89,90,99]
        
        nft.mint(alice,tokenIds);
    }

        function testIsPrime() public {
        uint256 primeCount = primeNFTFilter.findPrimeCount(alice);
        assertEq(primeCount, 7);
    
        }
      



}