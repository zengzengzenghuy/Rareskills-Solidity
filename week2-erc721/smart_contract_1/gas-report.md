
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