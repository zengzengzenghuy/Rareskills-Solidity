// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;
import "forge-std/Test.sol";

import {SanctionsToken} from "../src/SanctionsToken.sol";

contract SanctionsTokenTest is Test {
    address admin;
    address alice;
    address bob;
    address[] blackListedAddress;
    SanctionsToken public sanctionsToken;

    function setUp() public {
        blackListedAddress.push(makeAddr("badAddr1"));
        blackListedAddress.push(makeAddr("badAddr2"));

        alice = makeAddr("alice");
        bob = makeAddr("bob");
        admin = makeAddr("admin");

        sanctionsToken = new SanctionsToken("SancToken", "SCT", admin);
        vm.startPrank(admin);
        sanctionsToken.blackListaddress(blackListedAddress);
        sanctionsToken.mint(alice, 1000);
        sanctionsToken.mint(blackListedAddress[0], 1000);
        vm.stopPrank();
    }

    function testSetAdmin() public {
        address newAdmin = makeAddr("newAdmin");

        vm.expectEmit(true, false, false, false);
        emit SanctionsToken.AdminSet(address(newAdmin));
        vm.prank(admin);
        sanctionsToken.setAdmin(newAdmin);
    }

    function testTransfer() public {
        uint256 transferAmount = 20;
        uint256 aliceBalanceBefore = sanctionsToken.balanceOf(alice);
        uint256 bobBalanceBefore = sanctionsToken.balanceOf(bob);
        vm.prank(alice);
        sanctionsToken.transfer(bob, transferAmount);
        assertEq(
            sanctionsToken.balanceOf(alice),
            aliceBalanceBefore - transferAmount
        );
        assertEq(
            sanctionsToken.balanceOf(bob),
            bobBalanceBefore + transferAmount
        );
    }

    function testTransferFrom() public {
        address spender = makeAddr("spender");
        uint256 transferAmount = 20;
        uint256 aliceBalanceBefore = sanctionsToken.balanceOf(alice);
        uint256 bobBalanceBefore = sanctionsToken.balanceOf(bob);
        vm.prank(alice);
        sanctionsToken.approve(spender, transferAmount);
        vm.prank(spender);
        sanctionsToken.transferFrom(alice, bob, transferAmount);
        assertEq(
            sanctionsToken.balanceOf(alice),
            aliceBalanceBefore - transferAmount
        );
        assertEq(
            sanctionsToken.balanceOf(bob),
            bobBalanceBefore + transferAmount
        );
    }

    function testBlackListedTransfer() public {
        uint256 transferAmount = 50;

        vm.expectRevert("msg.sender is blacklisted");
        vm.prank(blackListedAddress[0]);
        sanctionsToken.transfer(alice, transferAmount);

        vm.expectRevert("recipient is blacklisted");
        vm.prank(alice);
        sanctionsToken.transfer(blackListedAddress[1], transferAmount);
    }
}
