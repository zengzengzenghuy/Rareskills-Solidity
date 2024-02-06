// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;
import "forge-std/Test.sol";
import {ERC777Mock} from "../src/tests/ERC777Mock.sol";
import {IERC777} from "@openzeppelin/contracts/token/ERC777/IERC777.sol";
import {ERC1363Mock} from "../src/tests/ERC1363Mock.sol";
import {ERC20Mock} from "../src/tests/ERC20Mock.sol";
import {ERC1820Registry} from "../src/tests/ERC1820Registry.sol";
import {EscrowToken} from "../src/EscrowToken.sol";
import {ERC777UserMock} from "../src/tests/ERC777UserMock.sol";
import {ERC1363UserMock} from "../src/tests/ERC1363UserMock.sol";

contract EscrowTokenTest is Test {
    ERC1363Mock erc1363Mock;
    ERC777Mock erc777Mock;
    ERC20Mock erc20;
    EscrowToken escrowToken;
    address buyer;
    address seller;
    uint256 timelock = 3 days;
    ERC1820Registry erc1820Registry;
    address[] defaultOperators;
    bytes32 ERC777RecipientInterface =
        0xb281fc8c12954d22544db45de3159a39272895b169a852b314f9cc762e44c53b;
    bytes32 ERC777SenderInterface =
        0x29ddb589b1fb5fc7cf394961c1adf5f8c6454761adf795e67fe149f658abe895;

    function setUp() public {
        defaultOperators.push(makeAddr("operator1"));
        defaultOperators.push(makeAddr("operator2"));
        buyer = makeAddr("buyer");
        seller = makeAddr("seller");
        erc1820Registry = new ERC1820Registry();
        erc1363Mock = new ERC1363Mock("1363 token", "ABT");
        erc777Mock = new ERC777Mock("777 token", "CDT", defaultOperators);
        erc777Mock.setERC1820Registry(address(erc1820Registry));
        erc20 = new ERC20Mock("20 token", "EFT");

        escrowToken = new EscrowToken();
        uint256 mintAmount = 100;
        erc20.mint(buyer, mintAmount);
        erc777Mock.mint(buyer, mintAmount);
        // erc1363Mock.mint(buyer, mintAmount);
    }

    // function testInitialAmount() public {
    //     uint256 mintAmount = 100;
    //     assertEq(erc20.balanceOf(buyer), mintAmount);
    //     assertEq(erc777Mock.balanceOf(buyer), mintAmount);
    //     assertEq(erc1363Mock.balanceOf(buyer), mintAmount);
    // }

    function testERC20DepositAndWithdraw() public {
        uint256 depositAmount = 10;
        uint256 depositTimestamp = block.timestamp;
        uint256 buyerBalanceBefore = erc20.balanceOf(buyer);
        uint256 sellerBalanceBefore = erc20.balanceOf(seller);
        uint256 escrowContractbalanceBefore = erc20.balanceOf(
            address(escrowToken)
        );
        vm.startPrank(buyer);
        erc20.approve(address(escrowToken), depositAmount);
        vm.expectEmit(address(escrowToken));
        emit EscrowToken.dealOpen(
            address(buyer),
            address(seller),
            depositAmount
        );
        escrowToken.depositToken(seller, depositAmount, address(erc20), 0);
        assertEq(erc20.balanceOf(buyer), buyerBalanceBefore - depositAmount);
        assertEq(
            erc20.balanceOf(address(escrowToken)),
            escrowContractbalanceBefore + depositAmount
        );
        vm.stopPrank();
        // test withdraw within 3 days;
        vm.warp(depositTimestamp + 1 days);
        vm.prank(seller);
        vm.expectRevert("seller has to wait 3 days to withdraw!");
        escrowToken.withdrawToken(buyer);

        // test withdraw after 3 days
        vm.warp(depositTimestamp + 3 days);
        vm.prank(seller);
        vm.expectEmit(address(escrowToken));
        emit EscrowToken.dealClosed(
            address(buyer),
            address(seller),
            depositAmount,
            block.timestamp
        );
        escrowToken.withdrawToken(buyer);
        assertEq(erc20.balanceOf(seller), sellerBalanceBefore + depositAmount);
        assertEq(
            erc20.balanceOf(address(escrowToken)),
            escrowContractbalanceBefore
        );
    }

    //TODO: test with ERC777 and ERC1363 token

    function testERC777DepositAndWithdraw() public {
        uint256 depositAmount = 10;
        uint256 depositTimestamp = block.timestamp;
        uint256 buyerBalanceBefore = erc777Mock.balanceOf(buyer);
        uint256 sellerBalanceBefore = erc777Mock.balanceOf(seller);
        uint256 escrowContractbalanceBefore = erc777Mock.balanceOf(
            address(escrowToken)
        );
        assertEq(buyerBalanceBefore, 100);
        vm.startPrank(buyer);
        erc777Mock.approve(address(escrowToken), depositAmount);

        vm.expectEmit(address(escrowToken));
        emit EscrowToken.dealOpen(
            address(buyer),
            address(seller),
            depositAmount
        );
        escrowToken.depositToken(seller, depositAmount, address(erc777Mock), 1);

        vm.stopPrank();
        // test withdraw within 3 days;
        vm.warp(depositTimestamp + 1 days);
        vm.prank(seller);
        vm.expectRevert("seller has to wait 3 days to withdraw!");
        escrowToken.withdrawToken(buyer);

        // test withdraw after 3 days
        vm.warp(depositTimestamp + 3 days);
        vm.prank(seller);
        vm.expectEmit(address(escrowToken));
        emit EscrowToken.dealClosed(
            address(buyer),
            address(seller),
            depositAmount,
            block.timestamp
        );
        escrowToken.withdrawToken(buyer);
        assertEq(
            erc777Mock.balanceOf(seller),
            sellerBalanceBefore + depositAmount
        );
        assertEq(
            erc777Mock.balanceOf(address(escrowToken)),
            escrowContractbalanceBefore
        );
    }

    function testERC777WithHookDepositAndWithdraw() public {
        uint256 depositAmount = 10;
        ERC777UserMock buyer = new ERC777UserMock();
        ERC777UserMock seller = new ERC777UserMock();

        vm.startPrank(address(buyer));
        erc1820Registry.setInterfaceImplementer(
            address(buyer),
            ERC777SenderInterface,
            address(buyer)
        );
        erc1820Registry.setInterfaceImplementer(
            address(buyer),
            ERC777RecipientInterface,
            address(buyer)
        );
        vm.stopPrank();

        vm.prank(address(seller));
        erc1820Registry.setInterfaceImplementer(
            address(seller),
            ERC777RecipientInterface,
            address(seller)
        );

        erc777Mock.mint(address(buyer), depositAmount);

        uint256 depositTimestamp = block.timestamp;
        uint256 buyerBalanceBefore = erc777Mock.balanceOf(address(buyer));
        uint256 sellerBalanceBefore = erc777Mock.balanceOf(address(seller));
        uint256 escrowContractbalanceBefore = erc777Mock.balanceOf(
            address(escrowToken)
        );
        assertEq(buyerBalanceBefore, depositAmount);
        vm.startPrank(address(buyer));
        erc777Mock.approve(address(escrowToken), depositAmount);

        vm.expectEmit(address(escrowToken));
        emit EscrowToken.dealOpen(
            address(buyer),
            address(seller),
            depositAmount
        );
        escrowToken.depositToken(
            address(seller),
            depositAmount,
            address(erc777Mock),
            1
        );

        vm.stopPrank();
        // test withdraw within 3 days;
        vm.warp(depositTimestamp + 1 days);
        vm.prank(address(seller));
        vm.expectRevert("seller has to wait 3 days to withdraw!");
        escrowToken.withdrawToken(address(buyer));

        // test withdraw after 3 days
        vm.warp(depositTimestamp + 3 days);
        vm.prank(address(seller));
        vm.expectEmit(address(escrowToken));
        emit EscrowToken.dealClosed(
            address(buyer),
            address(seller),
            depositAmount,
            block.timestamp
        );
        escrowToken.withdrawToken(address(buyer));
        assertEq(
            erc777Mock.balanceOf(address(seller)),
            sellerBalanceBefore + depositAmount
        );
        assertEq(
            erc777Mock.balanceOf(address(escrowToken)),
            escrowContractbalanceBefore
        );
    }

    function testERC1363DepositAndWithdraw() public {
        uint256 depositAmount = 10;

        ERC1363UserMock buyer = new ERC1363UserMock();
        ERC1363UserMock seller = new ERC1363UserMock();

        erc1363Mock.mint(address(buyer), depositAmount);
        uint256 depositTimestamp = block.timestamp;
        uint256 buyerBalanceBefore = erc1363Mock.balanceOf(address(buyer));
        uint256 sellerBalanceBefore = erc1363Mock.balanceOf(address(seller));
        uint256 escrowContractbalanceBefore = erc1363Mock.balanceOf(
            address(escrowToken)
        );
        assertEq(buyerBalanceBefore, depositAmount);

        vm.startPrank(address(buyer));
        erc1363Mock.approve(address(escrowToken), depositAmount);

        vm.expectEmit(address(escrowToken));
        emit EscrowToken.dealOpen(
            address(buyer),
            address(seller),
            depositAmount
        );
        escrowToken.depositToken(
            address(seller),
            depositAmount,
            address(erc1363Mock),
            2
        );

        vm.stopPrank();
        // test withdraw within 3 days;
        vm.warp(depositTimestamp + 1 days);
        vm.prank(address(seller));
        vm.expectRevert("seller has to wait 3 days to withdraw!");
        escrowToken.withdrawToken(address(buyer));

        // test withdraw after 3 days
        vm.warp(depositTimestamp + 3 days);
        vm.prank(address(seller));
        vm.expectEmit(address(escrowToken));
        emit EscrowToken.dealClosed(
            address(buyer),
            address(seller),
            depositAmount,
            block.timestamp
        );
        escrowToken.withdrawToken(address(buyer));
        assertEq(
            erc1363Mock.balanceOf(address(seller)),
            sellerBalanceBefore + depositAmount
        );
        assertEq(
            erc1363Mock.balanceOf(address(escrowToken)),
            escrowContractbalanceBefore
        );
    }
}
