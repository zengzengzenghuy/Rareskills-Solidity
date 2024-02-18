// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;
import "forge-std/Test.sol";

import {BondingCurveToken} from "../src/BondingCurveToken.sol";

import {ERC20Mock} from "../src/tests/ERC20Mock.sol";

contract BondingCurveTokenTest is Test {
    BondingCurveToken bcToken;
    ERC20Mock reserveToken;
    address alice;
    address bob;

    event BondingCurveTokenMinted(
        address indexed buyer,
        uint256 indexed tokenAmountMinted,
        uint256 indexed reservePaid
    );
    event BondingCurveTokenSold(
        address indexed seller,
        uint256 indexed tokenAmountBurnt,
        uint256 indexed reserveReturn
    );

    function setUp() public {
        reserveToken = new ERC20Mock("ReserveToken", "RST");
        bcToken = new BondingCurveToken("BondingCurveToken", "BCT");

        alice = makeAddr("alice");
        vm.deal(alice, 100 ether);
    }

    function testBuyToken() public {
        uint256 amountToBuy = 5;
        uint256 expectEthAmountToPay = 15 ether; // 1+2+3+4+5 = 15
        uint256 aliceEthBalanceBefore = alice.balance;

        vm.prank(alice);
        vm.expectEmit(address(bcToken));
        emit BondingCurveTokenMinted(alice, amountToBuy, expectEthAmountToPay);
        bcToken.buyToken{value: expectEthAmountToPay}(amountToBuy);

        assertEq(bcToken.balanceOf(alice), amountToBuy);
        assertEq(bcToken.totalSupply(), amountToBuy);
        assertEq(alice.balance, aliceEthBalanceBefore - expectEthAmountToPay);
    }

    function testSellToken() public {
        uint256 amountToSell = 5;
        uint256 expectEthAmountToGet = 15 ether; // 1+2+3+4+5 = 15

        uint256 buyTime = block.timestamp;
        vm.prank(alice);

        bcToken.buyToken{value: 15 ether}(5);

        vm.stopPrank();

        uint256 aliceEthBalanceBefore = alice.balance;
        uint256 aliceTokenBalanceBefore = bcToken.balanceOf(alice);
        uint256 bcTokenTotalSupplyBefore = bcToken.totalSupply();
        vm.warp(buyTime + 10 * 3600); // wait for 10 mins

        vm.prank(alice);
        vm.expectEmit(address(bcToken));
        emit BondingCurveTokenSold(alice, amountToSell, expectEthAmountToGet);
        bcToken.sellToken(amountToSell);

        assertEq(
            bcToken.totalSupply(),
            bcTokenTotalSupplyBefore - amountToSell
        );
        assertEq(
            bcToken.balanceOf(alice),
            aliceTokenBalanceBefore - amountToSell
        );
        assertEq(alice.balance, aliceEthBalanceBefore + expectEthAmountToGet);
    }

    function testSellBeforeCoolDownTime() public {
        uint256 amountToSell = 5;
        uint256 buyTime = block.timestamp;

        vm.startPrank(alice);
        bcToken.buyToken{value: 15 ether}(5);

        vm.warp(buyTime + 1 * 3600); // 1 minutes instead of 10

        vm.expectRevert("must wait for cool down time to sell token!");
        bcToken.sellToken(amountToSell);

        vm.stopPrank();
    }
}
