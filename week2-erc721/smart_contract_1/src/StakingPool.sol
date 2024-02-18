// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {RewardToken} from "./RewardToken.sol";
import {StakedToken} from "./StakedToken.sol";

contract StakingPool {
    RewardToken rewardToken;
    StakedToken stakedToken;
    uint256 private constant REWARD_PER_DAY = 20; // 20 ERC20 per day

    struct UserInfo {
        uint256 lastUpdated;
        uint256 amountStaked;
        uint256 totalRewards;
        uint256[] tokenIds;
    }

    mapping(address user => UserInfo userInfo) userInfo;

    constructor(address reward_, address staked_) {
        rewardToken = RewardToken(reward_);
        stakedToken = StakedToken(staked_);
    }

    function depositStakeToken(uint256 tokenId) public {
        require(
            stakedToken.ownerOf(tokenId) == msg.sender,
            "msg.sender is not the owner of tokenId!"
        );

        stakedToken.safeTransferFrom(msg.sender, address(this), tokenId);
        rewardToken.mint(msg.sender, 1e18);

        uint256 amountStaked = userInfo[msg.sender].amountStaked;

    // update the totalRewards since last update
        if (amountStaked != 0) {
            userInfo[msg.sender].totalRewards +=
                amountStaked *
                (((block.timestamp - userInfo[msg.sender].lastUpdated) *
                    REWARD_PER_DAY *
                    1e18) / 1 days);
        }
        userInfo[msg.sender].lastUpdated = block.timestamp;
        userInfo[msg.sender].tokenIds[amountStaked] = tokenId;
        userInfo[msg.sender].amountStaked += amountStaked + 1;
    }

    /// @notice withdraw staked NFT token(s) and get NFT and rewarded ERC20 token back
    /// @dev
    /// @param tokenId an array of tokenId to be withdrawn from staker.

    function withdrawStakeToken(uint256[] calldata tokenId) public {
        require(tokenId.length != 0, "no staked token to withdraw!");
        for (uint256 i = 0; i < tokenId.length; i++) {
            for (uint256 j = 0; j < userInfo[msg.sender].tokenIds.length; j++) {
                if (userInfo[msg.sender].tokenIds[j] == tokenId[i]) {
                    // swap the token index with last token in array
                    uint256 lastIndex = userInfo[msg.sender].tokenIds.length -
                        1;
                    userInfo[msg.sender].tokenIds[j] = userInfo[msg.sender]
                        .tokenIds[lastIndex];
                    userInfo[msg.sender].tokenIds[lastIndex] = 0;
                    userInfo[msg.sender].amountStaked -= 1;
                    stakedToken.safeTransferFrom(
                        address(this),
                        msg.sender,
                        tokenId[i]
                    );
                    withdrawAllRewardToken(msg.sender);
                }
            }
        }
    }

    function withdrawAllRewardToken(address owner) public {
        require(owner != address(0), "owner is not a valid address!");
        require(
            userInfo[owner].amountStaked != 0,
            "Owner don't have balance in staking pool!"
        );

        uint256 totalReward = userInfo[msg.sender].totalRewards +
            userInfo[owner].amountStaked *
            (((block.timestamp - userInfo[msg.sender].lastUpdated) *
                REWARD_PER_DAY *
                1e18) / 1 days);

        userInfo[msg.sender].totalRewards = 0;
        userInfo[msg.sender].lastUpdated = block.timestamp;
        rewardToken.mint(msg.sender, totalReward);
    }
}
