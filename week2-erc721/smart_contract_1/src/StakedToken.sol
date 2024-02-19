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
    uint256 public totalSupply;
    uint256 constant MAX_SUPPLY = 1000;
    constructor(
        string memory name_,
        string memory symbol_,
        bytes32 merkleRoot_
    ) ERC721(name_, symbol_) {
        merkleRoot = merkleRoot_;
        _setDefaultRoyalty(msg.sender, 250); // set 2.5% of reward rate
    }

    // function getRoyaltyInfo() public returns(address, uint96){
    //     address receiver = _defaultRoyaltyInfo.receiver;
    // }
    function supportsInterface(
        bytes4 interfaceId
    ) public view override(ERC721, ERC2981) returns (bool) {
        return super.supportsInterface(interfaceId);
    }

    function mintWithDiscount(
        bytes32[] calldata proof,
        uint256 index
    ) public payable {
        require(!_bitmapList.get(index), "Already claimed!");

        _verifyProof(proof, index, msg.sender);

        _bitmapList.set(index);
        totalSupply += 1;
        
        safeMint(msg.sender);
        payable(msg.sender).transfer((msg.value * _discount) / 100);
    }



    function safeMint(address to) public payable {
        totalSupply += 1;
        require(totalSupply<= MAX_SUPPLY, "max supply reached!");
        _safeMint(to, totalSupply, "");
    }

    function withdrawFunds() external onlyOwner {
        address contractOwner = owner();
        uint256 ethAmount = address(this).balance;
        require(ethAmount>0, "eth");
         (bool sent, bytes memory data) = contractOwner.call{value: ethAmount}("");
        require(sent, "Failed to send Ether");
    }

    function _verifyProof(
        bytes32[] memory proof,
        uint256 index,
        address addr
    ) private view {
        bytes32 leaf = keccak256(
            bytes.concat(keccak256(abi.encode(addr, index)))
        );
        bool result = MerkleProof.verify(proof, merkleRoot, leaf);
        require(result, "Proof is wrong");
    }
}
