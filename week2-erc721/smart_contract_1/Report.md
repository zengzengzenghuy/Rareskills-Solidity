
# Gas Report


Run `forge test --gas-report`

| src/RewardToken.sol:RewardToken contract |                 |       |        |       |         |
|------------------------------------------|-----------------|-------|--------|-------|---------|
| Deployment Cost                          | Deployment Size |       |        |       |         |
| 520245                                   | 3325            |       |        |       |         |
| Function Name                            | min             | avg   | median | max   | # calls |
| balanceOf                                | 562             | 562   | 562    | 562   | 3       |
| mint                                     | 2805            | 25705 | 26705  | 46605 | 4       |


| src/StakedToken.sol:StakedToken contract |                 |        |        |        |         |
|------------------------------------------|-----------------|--------|--------|--------|---------|
| Deployment Cost                          | Deployment Size |        |        |        |         |
| 1565540                                  | 8801            |        |        |        |         |
| Function Name                            | min             | avg    | median | max    | # calls |
| acceptOwnership                          | 5251            | 5251   | 5251   | 5251   | 1       |
| approve                                  | 25214           | 26814  | 27214  | 27214  | 5       |
| balanceOf                                | 612             | 1278   | 612    | 2612   | 3       |
| mintWithDiscount                         | 126180          | 126180 | 126180 | 126180 | 2       |
| owner                                    | 420             | 420    | 420    | 420    | 5       |
| ownerOf                                  | 646             | 827    | 646    | 2646   | 11      |
| safeMint                                 | 26074           | 47974  | 47974  | 69874  | 8       |
| safeTransferFrom                         | 5016            | 28103  | 37861  | 38861  | 6       |
| transferOwnership                        | 26447           | 26447  | 26447  | 26447  | 1       |
| withdrawFunds                            | 9500            | 9500   | 9500   | 9500   | 1       |


| src/StakingPool.sol:StakingPool contract |                 |        |        |        |         |
|------------------------------------------|-----------------|--------|--------|--------|---------|
| Deployment Cost                          | Deployment Size |        |        |        |         |
| 577984                                   | 2918            |        |        |        |         |
| Function Name                            | min             | avg    | median | max    | # calls |
| depositStakeToken                        | 38074           | 114098 | 133604 | 133604 | 5       |
| onERC721Received                         | 678             | 678    | 678    | 678    | 5       |
| withdrawAllRewardToken                   | 7073            | 40606  | 57373  | 57373  | 3       |
| withdrawStakeToken                       | 27955           | 27955  | 27955  | 27955  | 1       |


| test/StakedToken.t.sol:StakedTokenTest contract |                 |     |        |     |         |
|-------------------------------------------------|-----------------|-----|--------|-----|---------|
| Deployment Cost                                 | Deployment Size |     |        |     |         |
| 3448447                                         | 16917           |     |        |     |         |
| Function Name                                   | min             | avg | median | max | # calls |
| receive                                         | 55              | 55  | 55     | 55  | 1       |



# Coverage

`forge coverage`

| File                | % Lines         | % Statements    | % Branches     | % Funcs       |
|---------------------|-----------------|-----------------|----------------|---------------|
| src/RewardToken.sol | 100.00% (1/1)   | 100.00% (1/1)   | 100.00% (0/0)  | 100.00% (1/1) |
| src/StakedToken.sol | 94.12% (16/17)  | 90.91% (20/22)  | 50.00% (4/8)   | 80.00% (4/5)  |
| src/StakingPool.sol | 100.00% (31/31) | 100.00% (37/37) | 57.14% (8/14)  | 100.00% (4/4) |
| Total               | 97.96% (48/49)  | 96.67% (58/60)  | 54.55% (12/22) | 90.00% (9/10) |



# Slither

`slither .`

```shell

Math.mulDiv(uint256,uint256,uint256) (lib/openzeppelin-contracts/contracts/utils/math/Math.sol#55-134) performs a multiplication on the result of a division:
        -denominator = denominator / twos (lib/openzeppelin-contracts/contracts/utils/math/Math.sol#101)
        -inverse = (3 * denominator) ^ 2 (lib/openzeppelin-contracts/contracts/utils/math/Math.sol#116)
Math.mulDiv(uint256,uint256,uint256) (lib/openzeppelin-contracts/contracts/utils/math/Math.sol#55-134) performs a multiplication on the result of a division:
        -denominator = denominator / twos (lib/openzeppelin-contracts/contracts/utils/math/Math.sol#101)
        -inverse *= 2 - denominator * inverse (lib/openzeppelin-contracts/contracts/utils/math/Math.sol#120)
Math.mulDiv(uint256,uint256,uint256) (lib/openzeppelin-contracts/contracts/utils/math/Math.sol#55-134) performs a multiplication on the result of a division:
        -denominator = denominator / twos (lib/openzeppelin-contracts/contracts/utils/math/Math.sol#101)
        -inverse *= 2 - denominator * inverse (lib/openzeppelin-contracts/contracts/utils/math/Math.sol#121)
Math.mulDiv(uint256,uint256,uint256) (lib/openzeppelin-contracts/contracts/utils/math/Math.sol#55-134) performs a multiplication on the result of a division:
        -denominator = denominator / twos (lib/openzeppelin-contracts/contracts/utils/math/Math.sol#101)
        -inverse *= 2 - denominator * inverse (lib/openzeppelin-contracts/contracts/utils/math/Math.sol#122)
Math.mulDiv(uint256,uint256,uint256) (lib/openzeppelin-contracts/contracts/utils/math/Math.sol#55-134) performs a multiplication on the result of a division:
        -denominator = denominator / twos (lib/openzeppelin-contracts/contracts/utils/math/Math.sol#101)
        -inverse *= 2 - denominator * inverse (lib/openzeppelin-contracts/contracts/utils/math/Math.sol#123)
Math.mulDiv(uint256,uint256,uint256) (lib/openzeppelin-contracts/contracts/utils/math/Math.sol#55-134) performs a multiplication on the result of a division:
        -denominator = denominator / twos (lib/openzeppelin-contracts/contracts/utils/math/Math.sol#101)
        -inverse *= 2 - denominator * inverse (lib/openzeppelin-contracts/contracts/utils/math/Math.sol#124)
Math.mulDiv(uint256,uint256,uint256) (lib/openzeppelin-contracts/contracts/utils/math/Math.sol#55-134) performs a multiplication on the result of a division:
        -denominator = denominator / twos (lib/openzeppelin-contracts/contracts/utils/math/Math.sol#101)
        -inverse *= 2 - denominator * inverse (lib/openzeppelin-contracts/contracts/utils/math/Math.sol#125)
Math.mulDiv(uint256,uint256,uint256) (lib/openzeppelin-contracts/contracts/utils/math/Math.sol#55-134) performs a multiplication on the result of a division:
        -prod0 = prod0 / twos (lib/openzeppelin-contracts/contracts/utils/math/Math.sol#104)
        -result = prod0 * inverse (lib/openzeppelin-contracts/contracts/utils/math/Math.sol#131)
StakingPool.depositStakeToken(uint256) (src/StakingPool.sol#48-71) performs a multiplication on the result of a division:
        -userInfo[msg.sender].totalRewards += amountStaked * (((block.timestamp - userInfo[msg.sender].lastUpdated) * REWARD_PER_DAY * 1e18) / 86400) (src/StakingPool.sol#60-64)
StakingPool.withdrawAllRewardToken(address) (src/StakingPool.sol#108-126) performs a multiplication on the result of a division:
        -totalReward = userInfo[msg.sender].totalRewards + userInfo[owner].amountStaked * (((block.timestamp - userInfo[msg.sender].lastUpdated) * REWARD_PER_DAY * 1e18) / 86400) (src/StakingPool.sol#115-119)
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#divide-before-multiply

Reentrancy in StakingPool.withdrawStakeToken(uint256[]) (src/StakingPool.sol#77-104):
        External calls:
        - stakedToken.safeTransferFrom(address(this),msg.sender,tokenId[i]) (src/StakingPool.sol#90-94)
        - withdrawAllRewardToken(msg.sender) (src/StakingPool.sol#96)
                - rewardToken.mint(msg.sender,totalReward) (src/StakingPool.sol#123)
        State variables written after the call(s):
        - withdrawAllRewardToken(msg.sender) (src/StakingPool.sol#96)
                - userInfo[msg.sender].totalRewards = 0 (src/StakingPool.sol#121)
                - userInfo[msg.sender].lastUpdated = block.timestamp (src/StakingPool.sol#122)
        - userInfo[msg.sender].amountStaked -= 1 (src/StakingPool.sol#98)
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#reentrancy-vulnerabilities-1

ERC721._checkOnERC721Received(address,address,uint256,bytes) (lib/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol#399-421) ignores return value by IERC721Receiver(to).onERC721Received(_msgSender(),from,tokenId,data) (lib/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol#406-417)
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#unused-return

Ownable2Step.transferOwnership(address).newOwner (lib/openzeppelin-contracts/contracts/access/Ownable2Step.sol#35) lacks a zero-check on :
                - _pendingOwner = newOwner (lib/openzeppelin-contracts/contracts/access/Ownable2Step.sol#36)
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#missing-zero-address-validation

StakingPool.withdrawStakeToken(uint256[]) (src/StakingPool.sol#77-104) has external calls inside a loop: stakedToken.safeTransferFrom(address(this),msg.sender,tokenId[i]) (src/StakingPool.sol#90-94)
StakingPool.withdrawAllRewardToken(address) (src/StakingPool.sol#108-126) has external calls inside a loop: rewardToken.mint(msg.sender,totalReward) (src/StakingPool.sol#123)
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation/#calls-inside-a-loop

Variable 'ERC721._checkOnERC721Received(address,address,uint256,bytes).retval (lib/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol#406)' in ERC721._checkOnERC721Received(address,address,uint256,bytes) (lib/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol#399-421) potentially used before declaration: retval == IERC721Receiver.onERC721Received.selector (lib/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol#407)
Variable 'ERC721._checkOnERC721Received(address,address,uint256,bytes).reason (lib/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol#408)' in ERC721._checkOnERC721Received(address,address,uint256,bytes) (lib/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol#399-421) potentially used before declaration: reason.length == 0 (lib/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol#409)
Variable 'ERC721._checkOnERC721Received(address,address,uint256,bytes).reason (lib/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol#408)' in ERC721._checkOnERC721Received(address,address,uint256,bytes) (lib/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol#399-421) potentially used before declaration: revert(uint256,uint256)(32 + reason,mload(uint256)(reason)) (lib/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol#414)
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#pre-declaration-usage-of-local-variables

Reentrancy in StakingPool.depositStakeToken(uint256) (src/StakingPool.sol#48-71):
        External calls:
        - stakedToken.safeTransferFrom(msg.sender,address(this),tokenId) (src/StakingPool.sol#54)
        State variables written after the call(s):
        - userInfo[msg.sender].totalRewards += amountStaked * (((block.timestamp - userInfo[msg.sender].lastUpdated) * REWARD_PER_DAY * 1e18) / 86400) (src/StakingPool.sol#60-64)
        - userInfo[msg.sender].lastUpdated = block.timestamp (src/StakingPool.sol#66)
        - userInfo[msg.sender].tokenIds.push(tokenId) (src/StakingPool.sol#67)
        - userInfo[msg.sender].amountStaked += 1 (src/StakingPool.sol#68)
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#reentrancy-vulnerabilities-2

Reentrancy in StakingPool.depositStakeToken(uint256) (src/StakingPool.sol#48-71):
        External calls:
        - stakedToken.safeTransferFrom(msg.sender,address(this),tokenId) (src/StakingPool.sol#54)
        Event emitted after the call(s):
        - depositNFT(msg.sender,tokenId,block.timestamp) (src/StakingPool.sol#70)
Reentrancy in StakingPool.withdrawAllRewardToken(address) (src/StakingPool.sol#108-126):
        External calls:
        - rewardToken.mint(msg.sender,totalReward) (src/StakingPool.sol#123)
        Event emitted after the call(s):
        - withdrawRewardToken(msg.sender,totalReward,block.timestamp) (src/StakingPool.sol#125)
Reentrancy in StakingPool.withdrawStakeToken(uint256[]) (src/StakingPool.sol#77-104):
        External calls:
        - stakedToken.safeTransferFrom(address(this),msg.sender,tokenId[i]) (src/StakingPool.sol#90-94)
        - withdrawAllRewardToken(msg.sender) (src/StakingPool.sol#96)
                - rewardToken.mint(msg.sender,totalReward) (src/StakingPool.sol#123)
        Event emitted after the call(s):
        - withdrawNFT(msg.sender,tokenId[i],block.timestamp) (src/StakingPool.sol#100)
        - withdrawRewardToken(msg.sender,totalReward,block.timestamp) (src/StakingPool.sol#125)
                - withdrawAllRewardToken(msg.sender) (src/StakingPool.sol#96)
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#reentrancy-vulnerabilities-3

ERC721._checkOnERC721Received(address,address,uint256,bytes) (lib/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol#399-421) uses assembly
        - INLINE ASM (lib/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol#413-415)
Address._revert(bytes,string) (lib/openzeppelin-contracts/contracts/utils/Address.sol#231-243) uses assembly
        - INLINE ASM (lib/openzeppelin-contracts/contracts/utils/Address.sol#236-239)
Strings.toString(uint256) (lib/openzeppelin-contracts/contracts/utils/Strings.sol#19-39) uses assembly
        - INLINE ASM (lib/openzeppelin-contracts/contracts/utils/Strings.sol#25-27)
        - INLINE ASM (lib/openzeppelin-contracts/contracts/utils/Strings.sol#31-33)
MerkleProof._efficientHash(bytes32,bytes32) (lib/openzeppelin-contracts/contracts/utils/cryptography/MerkleProof.sol#219-226) uses assembly
        - INLINE ASM (lib/openzeppelin-contracts/contracts/utils/cryptography/MerkleProof.sol#221-225)
Math.mulDiv(uint256,uint256,uint256) (lib/openzeppelin-contracts/contracts/utils/math/Math.sol#55-134) uses assembly
        - INLINE ASM (lib/openzeppelin-contracts/contracts/utils/math/Math.sol#62-66)
        - INLINE ASM (lib/openzeppelin-contracts/contracts/utils/math/Math.sol#85-92)
        - INLINE ASM (lib/openzeppelin-contracts/contracts/utils/math/Math.sol#99-108)
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#assembly-usage

Different versions of Solidity are used:
        - Version used: ['^0.8.0', '^0.8.1', '^0.8.13']
        - ^0.8.0 (lib/openzeppelin-contracts/contracts/access/Ownable.sol#4)
        - ^0.8.0 (lib/openzeppelin-contracts/contracts/access/Ownable2Step.sol#4)
        - ^0.8.0 (lib/openzeppelin-contracts/contracts/interfaces/IERC2981.sol#4)
        - ^0.8.0 (lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol#4)
        - ^0.8.0 (lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol#4)
        - ^0.8.0 (lib/openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Metadata.sol#4)
        - ^0.8.0 (lib/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol#4)
        - ^0.8.0 (lib/openzeppelin-contracts/contracts/token/ERC721/IERC721.sol#4)
        - ^0.8.0 (lib/openzeppelin-contracts/contracts/token/ERC721/IERC721Receiver.sol#4)
        - ^0.8.0 (lib/openzeppelin-contracts/contracts/token/ERC721/extensions/IERC721Metadata.sol#4)
        - ^0.8.0 (lib/openzeppelin-contracts/contracts/token/common/ERC2981.sol#4)
        - ^0.8.1 (lib/openzeppelin-contracts/contracts/utils/Address.sol#4)
        - ^0.8.0 (lib/openzeppelin-contracts/contracts/utils/Context.sol#4)
        - ^0.8.0 (lib/openzeppelin-contracts/contracts/utils/Strings.sol#4)
        - ^0.8.0 (lib/openzeppelin-contracts/contracts/utils/cryptography/MerkleProof.sol#4)
        - ^0.8.0 (lib/openzeppelin-contracts/contracts/utils/introspection/ERC165.sol#4)
        - ^0.8.0 (lib/openzeppelin-contracts/contracts/utils/introspection/IERC165.sol#4)
        - ^0.8.0 (lib/openzeppelin-contracts/contracts/utils/math/Math.sol#4)
        - ^0.8.0 (lib/openzeppelin-contracts/contracts/utils/math/SignedMath.sol#4)
        - ^0.8.0 (lib/openzeppelin-contracts/contracts/utils/structs/BitMaps.sol#3)
        - ^0.8.13 (src/RewardToken.sol#2)
        - ^0.8.13 (src/StakedToken.sol#2)
        - ^0.8.13 (src/StakingPool.sol#2)
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#different-pragma-directives-are-used

Pragma version^0.8.0 (lib/openzeppelin-contracts/contracts/access/Ownable.sol#4) allows old versions
Pragma version^0.8.0 (lib/openzeppelin-contracts/contracts/access/Ownable2Step.sol#4) allows old versions
Pragma version^0.8.0 (lib/openzeppelin-contracts/contracts/interfaces/IERC2981.sol#4) allows old versions
Pragma version^0.8.0 (lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol#4) allows old versions
Pragma version^0.8.0 (lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol#4) allows old versions
Pragma version^0.8.0 (lib/openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Metadata.sol#4) allows old versions
Pragma version^0.8.0 (lib/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol#4) allows old versions
Pragma version^0.8.0 (lib/openzeppelin-contracts/contracts/token/ERC721/IERC721.sol#4) allows old versions
Pragma version^0.8.0 (lib/openzeppelin-contracts/contracts/token/ERC721/IERC721Receiver.sol#4) allows old versions
Pragma version^0.8.0 (lib/openzeppelin-contracts/contracts/token/ERC721/extensions/IERC721Metadata.sol#4) allows old versions
Pragma version^0.8.0 (lib/openzeppelin-contracts/contracts/token/common/ERC2981.sol#4) allows old versions
Pragma version^0.8.1 (lib/openzeppelin-contracts/contracts/utils/Address.sol#4) allows old versions
Pragma version^0.8.0 (lib/openzeppelin-contracts/contracts/utils/Context.sol#4) allows old versions
Pragma version^0.8.0 (lib/openzeppelin-contracts/contracts/utils/Strings.sol#4) allows old versions
Pragma version^0.8.0 (lib/openzeppelin-contracts/contracts/utils/cryptography/MerkleProof.sol#4) allows old versions
Pragma version^0.8.0 (lib/openzeppelin-contracts/contracts/utils/introspection/ERC165.sol#4) allows old versions
Pragma version^0.8.0 (lib/openzeppelin-contracts/contracts/utils/introspection/IERC165.sol#4) allows old versions
Pragma version^0.8.0 (lib/openzeppelin-contracts/contracts/utils/math/Math.sol#4) allows old versions
Pragma version^0.8.0 (lib/openzeppelin-contracts/contracts/utils/math/SignedMath.sol#4) allows old versions
Pragma version^0.8.0 (lib/openzeppelin-contracts/contracts/utils/structs/BitMaps.sol#3) allows old versions
Pragma version^0.8.13 (src/RewardToken.sol#2) necessitates a version too recent to be trusted. Consider deploying with 0.6.12/0.7.6/0.8.7
Pragma version^0.8.13 (src/StakedToken.sol#2) necessitates a version too recent to be trusted. Consider deploying with 0.6.12/0.7.6/0.8.7
Pragma version^0.8.13 (src/StakingPool.sol#2) necessitates a version too recent to be trusted. Consider deploying with 0.6.12/0.7.6/0.8.7
solc-0.8.22 is not recommended for deployment
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#incorrect-versions-of-solidity

Low level call in Address.sendValue(address,uint256) (lib/openzeppelin-contracts/contracts/utils/Address.sol#64-69):
        - (success) = recipient.call{value: amount}() (lib/openzeppelin-contracts/contracts/utils/Address.sol#67)
Low level call in Address.functionCallWithValue(address,bytes,uint256,string) (lib/openzeppelin-contracts/contracts/utils/Address.sol#128-137):
        - (success,returndata) = target.call{value: value}(data) (lib/openzeppelin-contracts/contracts/utils/Address.sol#135)
Low level call in Address.functionStaticCall(address,bytes,string) (lib/openzeppelin-contracts/contracts/utils/Address.sol#155-162):
        - (success,returndata) = target.staticcall(data) (lib/openzeppelin-contracts/contracts/utils/Address.sol#160)
Low level call in Address.functionDelegateCall(address,bytes,string) (lib/openzeppelin-contracts/contracts/utils/Address.sol#180-187):
        - (success,returndata) = target.delegatecall(data) (lib/openzeppelin-contracts/contracts/utils/Address.sol#185)
Low level call in StakedToken.withdrawFunds() (src/StakedToken.sol#68-75):
        - (sent,data) = contractOwner.call{value: ethAmount}() (src/StakedToken.sol#71-73)
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#low-level-calls

StakingPool (src/StakingPool.sol#11-140) should inherit from IERC721Receiver (lib/openzeppelin-contracts/contracts/token/ERC721/IERC721Receiver.sol#11-27)
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#missing-inheritance

Function ERC721.__unsafe_increaseBalance(address,uint256) (lib/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol#463-465) is not in mixedCase
Event StakingPooldepositNFT(address,uint256,uint256) (src/StakingPool.sol#25-29) is not in CapWords
Event StakingPoolwithdrawNFT(address,uint256,uint256) (src/StakingPool.sol#30-34) is not in CapWords
Event StakingPoolwithdrawRewardToken(address,uint256,uint256) (src/StakingPool.sol#35-39) is not in CapWords
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#conformance-to-solidity-naming-conventions

renounceOwnership() should be declared external:
        - Ownable.renounceOwnership() (lib/openzeppelin-contracts/contracts/access/Ownable.sol#61-63)
transferOwnership(address) should be declared external:
        - Ownable.transferOwnership(address) (lib/openzeppelin-contracts/contracts/access/Ownable.sol#69-72)
        - Ownable2Step.transferOwnership(address) (lib/openzeppelin-contracts/contracts/access/Ownable2Step.sol#35-38)
acceptOwnership() should be declared external:
        - Ownable2Step.acceptOwnership() (lib/openzeppelin-contracts/contracts/access/Ownable2Step.sol#52-56)
name() should be declared external:
        - ERC20.name() (lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol#62-64)
symbol() should be declared external:
        - ERC20.symbol() (lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol#70-72)
decimals() should be declared external:
        - ERC20.decimals() (lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol#87-89)
totalSupply() should be declared external:
        - ERC20.totalSupply() (lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol#94-96)
balanceOf(address) should be declared external:
        - ERC20.balanceOf(address) (lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol#101-103)
transfer(address,uint256) should be declared external:
        - ERC20.transfer(address,uint256) (lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol#113-117)
approve(address,uint256) should be declared external:
        - ERC20.approve(address,uint256) (lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol#136-140)
transferFrom(address,address,uint256) should be declared external:
        - ERC20.transferFrom(address,address,uint256) (lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol#158-163)
increaseAllowance(address,uint256) should be declared external:
        - ERC20.increaseAllowance(address,uint256) (lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol#177-181)
decreaseAllowance(address,uint256) should be declared external:
        - ERC20.decreaseAllowance(address,uint256) (lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol#197-206)
balanceOf(address) should be declared external:
        - ERC721.balanceOf(address) (lib/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol#62-65)
name() should be declared external:
        - ERC721.name() (lib/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol#79-81)
symbol() should be declared external:
        - ERC721.symbol() (lib/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol#86-88)
tokenURI(uint256) should be declared external:
        - ERC721.tokenURI(uint256) (lib/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol#93-98)
approve(address,uint256) should be declared external:
        - ERC721.approve(address,uint256) (lib/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol#112-122)
setApprovalForAll(address,bool) should be declared external:
        - ERC721.setApprovalForAll(address,bool) (lib/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol#136-138)
transferFrom(address,address,uint256) should be declared external:
        - ERC721.transferFrom(address,address,uint256) (lib/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol#150-155)
safeTransferFrom(address,address,uint256) should be declared external:
        - ERC721.safeTransferFrom(address,address,uint256) (lib/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol#160-162)
royaltyInfo(uint256,uint256) should be declared external:
        - ERC2981.royaltyInfo(uint256,uint256) (lib/openzeppelin-contracts/contracts/token/common/ERC2981.sol#43-53)
mintWithDiscount(bytes32[],uint256) should be declared external:
        - StakedToken.mintWithDiscount(bytes32[],uint256) (src/StakedToken.sol#44-55)
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#public-function-that-could-be-declared-external
. analyzed (23 contracts with 78 detectors), 85 result(s) found
```