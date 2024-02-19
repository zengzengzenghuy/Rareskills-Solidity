// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;
import "forge-std/Test.sol";

import {StakingPool} from "../src/StakingPool.sol";
import {RewardToken} from "../src/RewardToken.sol";
import {StakedToken} from "../src/StakedToken.sol";

contract StakingPoolTest is Test{
    StakingPool stakingPool;
    RewardToken rewardToken;
    StakedToken stakedToken;

    bytes32 merkleRoot = 0x32b4c77a35d1797955dddb132a0a83fe87d9039b971269bfe9b094131591e19d;
    address claimer = 0x4444444444444444444444444444444444444444;
    address alice;

    function setUp() public {
        rewardToken = new RewardToken("Reward Token","RWT");
        stakedToken = new StakedToken("Staked Token","STT",merkleRoot);
        stakingPool = new StakingPool(address(rewardToken),address(stakedToken));
        alice = makeAddr("alice");

        vm.deal(claimer, 10 ether);
        vm.deal(alice, 10 ether);
        vm.prank(alice);
        stakedToken.safeMint{value: 1 ether}(alice);
    }

    function testDepositStakeToken() public {

        assertEq(stakedToken.balanceOf(alice),1);
        assertEq(stakedToken.ownerOf(1), alice);

        vm.startPrank(alice);
        stakedToken.approve(address(stakingPool),1);
        stakingPool.depositStakeToken(1);

        assertEq(rewardToken.balanceOf(alice),1e18);
        vm.stopPrank();
    }

    function testWithdrawStakeToken() public {
  
        vm.startPrank(alice);
        stakedToken.approve(address(stakingPool),1);
        stakingPool.depositStakeToken(1);

        assertEq(stakedToken.ownerOf(1),address(stakingPool));
        uint256[] memory tokenIds = new uint256[](1);
        tokenIds[0] = 1;
        stakingPool.withdrawStakeToken(tokenIds);

        vm.stopPrank();
        assertEq(stakedToken.ownerOf(1),alice);
    }
}