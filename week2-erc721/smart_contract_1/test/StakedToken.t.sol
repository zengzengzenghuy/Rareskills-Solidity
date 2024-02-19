// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;
import "forge-std/Test.sol";

import {StakedToken} from "../src/StakedToken.sol";

contract StakedTokenTest is Test{
    receive() external payable {}

    StakedToken stakedToken; 
    bytes32 merkleRoot = 0x32b4c77a35d1797955dddb132a0a83fe87d9039b971269bfe9b094131591e19d;
    address claimer = 0x4444444444444444444444444444444444444444;
    address owner;


    event OwnershipTransferStarted(address indexed previousOwner, address indexed newOwner);

    function setUp() public{
        stakedToken = new StakedToken("BitToken","BTT", merkleRoot);
        owner = stakedToken.owner();
        vm.deal(claimer, 1 ether);

    }

    function testSample() public{
        assertEq(merkleRoot,merkleRoot);
    }
    
    function testmintWithDiscount() public {
        bytes32[] memory proof = new bytes32[](3);
        proof[0]=0x60648906e1a3f55dd188e992dc24db68c6b6d455fe925705f5e110ed7889ad90;
        proof[1]=0x1c9f49112980e3497923e5b9211f64095a1c5d8b2afeb9dda9c89fbdc108e3b4;
        proof[2]=0x9af1dc97c972c581e3038f4acfae9614e511b3398aef14062e7ffc06b3486508;
    
        vm.prank(claimer);
        stakedToken.mintWithDiscount{value: 1 ether}(proof,4);

        assertEq(stakedToken.balanceOf(claimer),1);
        assertEq(claimer.balance, 0.1 ether);

    }

    function testWithdrawFunds() public {
          bytes32[] memory proof = new bytes32[](3);
        proof[0]=0x60648906e1a3f55dd188e992dc24db68c6b6d455fe925705f5e110ed7889ad90;
        proof[1]=0x1c9f49112980e3497923e5b9211f64095a1c5d8b2afeb9dda9c89fbdc108e3b4;
        proof[2]=0x9af1dc97c972c581e3038f4acfae9614e511b3398aef14062e7ffc06b3486508;
    
        vm.prank(claimer);
        stakedToken.mintWithDiscount{value: 1 ether}(proof,4);

        assertEq(stakedToken.balanceOf(claimer),1);
        assertEq(claimer.balance, 0.1 ether);




        uint256 totalFunds = address(stakedToken).balance;
        uint256 ownerBalanceBefore = owner.balance;

        vm.prank(owner);
        stakedToken.withdrawFunds();
        console.log(address(stakedToken).balance);
        console.log(claimer.balance);

        assertEq(owner.balance, ownerBalanceBefore + totalFunds);
        assertEq(address(stakedToken).balance, 0);

    }

    function testTransferOwnership() public {
        address newOwner = makeAddr("newOWner");

        vm.prank(owner);
        vm.expectEmit(address(stakedToken));
        emit OwnershipTransferStarted(owner,newOwner);
        stakedToken.transferOwnership(newOwner);

        vm.prank(newOwner);
        stakedToken.acceptOwnership();

        assertEq(stakedToken.owner(),newOwner);
    }
}