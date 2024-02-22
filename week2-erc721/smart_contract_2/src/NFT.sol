// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;
import {ERC721Enumerable} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Ownable2Step} from "@openzeppelin/contracts/access/Ownable2Step.sol";

contract NFT is ERC721Enumerable, Ownable2Step {
    constructor(
        string memory name_,
        string memory symbol_
    ) ERC721(name_, symbol_) {}

    function mint(
        address receiver,
        uint256[] calldata tokenIds
    ) public onlyOwner {
        for (uint256 i = 0; i < tokenIds.length; i++) {
            require(tokenIds[i] <= 100, "token id exceed 100!");
            super._safeMint(receiver, tokenIds[i]);
        }
    }
}
