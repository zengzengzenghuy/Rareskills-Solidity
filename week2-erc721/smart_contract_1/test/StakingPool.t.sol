// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;
import "forge-std/Test.sol";

import {StakingPool} from "../src/StakingPool.sol";
import {RewardToken} from "../src/RewardToken.sol";
import {StakedToken} from "../src/StakedToken.sol";

contract StakingPoolTest is Test{
      uint256 private constant REWARD_PER_DAY = 20; // 20 ERC20 per day

    StakingPool stakingPool;
    RewardToken rewardToken;
    StakedToken stakedToken;

    bytes32 merkleRoot = 0x32b4c77a35d1797955dddb132a0a83fe87d9039b971269bfe9b094131591e19d;
    address claimer = 0x4444444444444444444444444444444444444444;
    address alice;

       event depositNFT(address indexed depositor, uint256 indexed tokenId, uint256 indexed blockTimestamp);
    event withdrawNFT(address indexed withdrawer, uint256 indexed tokenId, uint256 blockTimestamp);
    event withdrawRewardToken(address indexed withdrawer, uint256 amount, uint256 indexed blockTimestamp);

    function setUp() public {
        rewardToken = new RewardToken("Reward Token","RWT");
        stakedToken = new StakedToken("Staked Token","STT",merkleRoot);
        stakingPool = new StakingPool(address(rewardToken),address(stakedToken));
        alice = makeAddr("alice");

        vm.deal(claimer, 10 ether);
        vm.deal(alice, 10 ether);
        vm.prank(alice);
        stakedToken.safeMint{value: 1 ether}(alice);  // tokenId = 1
        stakedToken.safeMint{value: 1 ether}(alice);  // tokenId = 2
    }

    function testDepositStakeToken() public {
        uint256 tokenId = 1;

        assertEq(stakedToken.balanceOf(alice),2);
        assertEq(stakedToken.ownerOf(tokenId), alice);

        vm.startPrank(alice);
        stakedToken.approve(address(stakingPool),tokenId);

        vm.expectEmit(address(stakingPool));
        emit depositNFT(alice, tokenId, block.timestamp);
        stakingPool.depositStakeToken(tokenId);


        vm.stopPrank();
    }

    function testWithdrawStakeToken() public {
                uint256 tokenId = 1;
        vm.startPrank(alice);
        stakedToken.approve(address(stakingPool),1);
        stakingPool.depositStakeToken(1);

        assertEq(stakedToken.ownerOf(1),address(stakingPool));
        uint256[] memory tokenIds = new uint256[](1);
        tokenIds[0] = 1;
        vm.expectEmit(address(stakingPool));
        emit withdrawNFT(alice, tokenId, block.timestamp);
        emit withdrawRewardToken(alice, 0, block.timestamp);
        stakingPool.withdrawStakeToken(tokenIds);

        vm.stopPrank();
        assertEq(stakedToken.ownerOf(1),alice);
    }

    function testWithdrawAllReward() public {

        uint256 blockTimestamp = block.timestamp;
        vm.startPrank(alice);
        stakedToken.approve(address(stakingPool),1);
        stakingPool.depositStakeToken(1);

        assertEq(stakedToken.ownerOf(1),address(stakingPool));

        vm.warp(blockTimestamp+ 2 days); // withdraw after 2 days

        vm.expectEmit(address(stakingPool));
        emit withdrawRewardToken(alice, 2*REWARD_PER_DAY*1e18, block.timestamp);
        stakingPool.withdrawAllRewardToken(alice);
        assertEq(rewardToken.balanceOf(alice), 2*REWARD_PER_DAY*1e18);
        
        vm.stopPrank();
    }

    function testMultipleDepositAndWithdraw() public {

        uint256 blockTimestamp = block.timestamp;
        vm.startPrank(alice);
        stakedToken.approve(address(stakingPool),1);
        stakingPool.depositStakeToken(1);
      

        assertEq(stakedToken.ownerOf(1),address(stakingPool));

        uint256 updateTimestamp = blockTimestamp+ 1 days;
        vm.warp(updateTimestamp); // withdraw after 1 days

        stakingPool.withdrawAllRewardToken(alice);
      
        assertEq(rewardToken.balanceOf(alice), REWARD_PER_DAY*1e18);  // 20 reward token

        stakedToken.approve(address(stakingPool),2);
        stakingPool.depositStakeToken(2);
        assertEq(stakedToken.ownerOf(2),address(stakingPool));

        updateTimestamp += 3 days;
        vm.warp(updateTimestamp);   // withdraw after 1 days

        uint256[] memory tokenIds = new uint256[](2);
        tokenIds[0] = 1;
        tokenIds[1] = 2;

        // stakingPool.withdrawStakeToken(tokenIds);
        stakingPool.withdrawAllRewardToken(alice);
        assertEq(rewardToken.balanceOf(alice), (1+3*2)*REWARD_PER_DAY*1e18);  // 20 (from last withdraw) + 2*3*20 (2 tokens * 3 days)
        
        vm.stopPrank();
    }
}