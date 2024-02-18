// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {IERC165} from "@openzeppelin/contracts/utils/introspection/IERC165.sol";
import {ERC165} from "@openzeppelin/contracts/utils/introspection/ERC165.sol";
import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {IERC2981} from "@openzeppelin/contracts/interfaces/IERC2981.sol";
import {ERC2981} from "@openzeppelin/contracts/token/common/ERC2981.sol";
import {Ownable2Step} from "@openzeppelin/contracts/access/Ownable2Step.sol";
import {MerkleProof} from "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";

import "@openzeppelin/contracts/utils/structs/BitMaps.sol";

contract StakedToken is ERC721, ERC2981, Ownable2Step {
    using BitMaps for BitMaps.BitMap;
    BitMaps.BitMap private _bitmapList;
    bytes32 public immutable merkleRoot;
    uint256 private immutable _discount = 10; // discount for addresses in a merkle tree

    constructor(
        string memory name_,
        string memory symbol_,
        bytes32 merkleRoot_
    ) ERC721(name_, symbol_) {
        merkleRoot = merkleRoot_;
        _mint(msg.sender, 1000);
        _setDefaultRoyalty(msg.sender, 250); // set 2.5% of reward rate
    }

    function supportsInterface(
        bytes4 interfaceId
    ) public view override(ERC721, ERC2981) returns (bool) {
        return super.supportsInterface(interfaceId);
    }

    function mintWithDiscount(
        bytes32[] calldata proof,
        uint256 index,
        uint256 tokenId
    ) public payable {
        require(!_bitmapList.get(index), "Already claimed!");

        _verifyProof(proof, index, msg.sender);

        _bitmapList.set(index);
        safeMint(msg.sender, tokenId);
        payable(address(this)).transfer((msg.value * _discount) / 100);
    }

    function safeMint(address to, uint256 tokenId) public payable {
        _safeMint(to, tokenId, "");
    }

    function withdrawFunds() external onlyOwner {
        address owner = owner();
        payable(owner).transfer(balanceOf(address(this)));
    }

    function _verifyProof(
        bytes32[] memory proof,
        uint256 index,
        address addr
    ) private view {
        bytes32 leaf = keccak256(
            bytes.concat(keccak256(abi.encode(index, addr)))
        );
        bool result = MerkleProof.verify(proof, merkleRoot, leaf);
        require(result, "Proof is wrong");
    }
}
