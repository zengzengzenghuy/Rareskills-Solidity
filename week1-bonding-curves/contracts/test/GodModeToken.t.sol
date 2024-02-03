// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;
import "forge-std/Test.sol";

import {GodModeToken} from "../src/GodModeToken.sol";

contract GodModeTokenTest is Test {
    address specialAddr;
    address alice;
    address bob;

    GodModeToken public godModeToken;

    function setUp() public {
        specialAddr = makeAddr("specialAddress");
        alice = makeAddr("alice");
        bob = makeAddr("bob");
        godModeToken = new GodModeToken("GodModToken", "GMT", specialAddr);
        godModeToken.mint(alice, 1000);
        godModeToken.mint(bob, 1000);
    }

    function testTransferFrom() public {
        address chris = makeAddr("chris");

        vm.expectRevert("ERC20: insufficient allowance");
        vm.prank(chris);
        godModeToken.transferFrom(alice, bob, 10);

        vm.prank(specialAddr);
        godModeToken.transferFrom(alice, bob, 10);
    }
}
