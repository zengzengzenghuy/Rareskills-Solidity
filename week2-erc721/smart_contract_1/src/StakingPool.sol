// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {RewardToken} from "./RewardToken.sol";
import {StakedToken} from "./StakedToken.sol";

/// @title Staking Pool
/// @author zeng
/// @dev Receive staked Token (NFT), and mint reward Token (ERC20) for depositor
/// @dev A staked Token can earn 20 reward token per day
contract StakingPool {
    RewardToken rewardToken;
    StakedToken stakedToken;
    uint256 private constant REWARD_PER_DAY = 20; // 20 ERC20 per day

    struct UserInfo {
        uint256 lastUpdated;
        uint256 amountStaked; // amount of NFT staked
        uint256 totalRewards; // total Rewards that can be withdrawn
        uint256[] tokenIds; // tokenIds that is deposited by user
    }

    mapping(address user => UserInfo userInfo) userInfo;

    event depositNFT(
        address indexed depositor,
        uint256 indexed tokenId,
        uint256 indexed blockTimestamp
    );
    event withdrawNFT(
        address indexed withdrawer,
        uint256 indexed tokenId,
        uint256 blockTimestamp
    );
    event withdrawRewardToken(
        address indexed withdrawer,
        uint256 amount,
        uint256 indexed blockTimestamp
    );

    constructor(address reward_, address staked_) {
        rewardToken = RewardToken(reward_);
        stakedToken = StakedToken(staked_);
    }

    /// @notice deposit StakeToken(NFT)
    /// @param tokenId tokenId to deposit
    function depositStakeToken(uint256 tokenId) external {
        require(
            stakedToken.ownerOf(tokenId) == msg.sender,
            "msg.sender is not the owner of tokenId!"
        );

        stakedToken.safeTransferFrom(msg.sender, address(this), tokenId);

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
        userInfo[msg.sender].tokenIds.push(tokenId);
        userInfo[msg.sender].amountStaked += 1;

        emit depositNFT(msg.sender, tokenId, block.timestamp);
    }

    /// @notice withdraw staked NFT token(s) and get NFT and rewarded ERC20 token back
    /// @dev
    /// @param tokenId an array of tokenId to be withdrawn from staker.

    function withdrawStakeToken(uint256[] calldata tokenId) external {
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

                    stakedToken.safeTransferFrom(
                        address(this),
                        msg.sender,
                        tokenId[i]
                    ); // transfer NFT back to user

                    withdrawAllRewardToken(msg.sender);

                    userInfo[msg.sender].amountStaked -= 1;

                    emit withdrawNFT(msg.sender, tokenId[i], block.timestamp);
                }
            }
        }
    }

    /// @notice withdraw all available reward token that owner has accumulated
    /// @param owner address to withdraw
    function withdrawAllRewardToken(address owner) public {
        require(msg.sender == owner, "only owner can withdraw");
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

        emit withdrawRewardToken(msg.sender, totalReward, block.timestamp);
    }

    function onERC721Received(
        address _operator,
        address _from,
        uint256 _tokenId,
        bytes calldata _data
    ) external returns (bytes4) {
        require(msg.sender == address(stakedToken), "msg.sender is not staked token contract!" );
        return
            bytes4(
                keccak256("onERC721Received(address,address,uint256,bytes)")
            );
    }
}
