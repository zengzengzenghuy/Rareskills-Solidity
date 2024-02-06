// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;
import "forge-std/Test.sol";

import {BondingCurveToken} from "../src/BondingCurveToken.sol";
import {BancorFormula} from "../src/utils/BancorFormula.sol";
import {ERC20Mock} from "../src/tests/ERC20Mock.sol";

contract BondingCurveTokenTest is Test {
    BondingCurveToken bcToken;
    ERC20Mock reserveToken;
    address alice;
    address bob;

    function setUp() public {
        reserveToken = new ERC20Mock("ReserveToken", "RST");
        bcToken = new BondingCurveToken(
            "BondingCurveToken",
            "BCT",
            100,
            address(reserveToken)
        );

        alice = makeAddr("alice");
        bob = makeAddr("bob");
        reserveToken.mint(alice, 1000);
    }

    function testBuyToken() public {
        vm.startPrank(alice);
        uint256 buyTime = block.timestamp;
        reserveToken.approve(address(bcToken), 1);
        bcToken.buyToken(1);
        vm.warp(buyTime + 10 * 3600);

        bcToken.sellToken(1000);
        vm.stopPrank();
    }
}
