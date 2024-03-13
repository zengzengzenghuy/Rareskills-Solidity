# Gas Report

[PASS] testIsPrime() (gas: 100687)
Test result: ok. 1 passed; 0 failed; 0 skipped; finished in 4.25ms
| src/NFT.sol:NFT contract |                 |         |         |         |         |
|--------------------------|-----------------|---------|---------|---------|---------|
| Deployment Cost          | Deployment Size |         |         |         |         |
| 1462821                  | 8045            |         |         |         |         |
| Function Name            | min             | avg     | median  | max     | # calls |
| balanceOf                | 2722            | 2722    | 2722    | 2722    | 1       |
| mint                     | 2304394         | 2304394 | 2304394 | 2304394 | 1       |
| tokenOfOwnerByIndex      | 2975            | 2975    | 2975    | 2975    | 20      |


| src/PrimeNFTFilter.sol:PrimeNFTFilter contract |                 |       |        |       |         |
|------------------------------------------------|-----------------|-------|--------|-------|---------|
| Deployment Cost                                | Deployment Size |       |        |       |         |
| 166539                                         | 899             |       |        |       |         |
| Function Name                                  | min             | avg   | median | max   | # calls |
| findPrimeCount                                 | 93343           | 93343 | 93343  | 93343 | 1       |

# Coverage

| File                   | % Lines         | % Statements   | % Branches   | % Funcs       |
|------------------------|-----------------|----------------|--------------|---------------|
| src/NFT.sol            | 100.00% (3/3)   | 100.00% (5/5)  | 50.00% (1/2) | 100.00% (1/1) |
| src/PrimeNFTFilter.sol | 100.00% (11/11) | 95.00% (19/20) | 83.33% (5/6) | 100.00% (2/2) |
| Total                  | 100.00% (14/14) | 96.00% (24/25) | 75.00% (6/8) | 100.00% (3/3) |


# Slither

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
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#divide-before-multiply

PrimeNFTFilter.findPrimeCount(address).primeCount (src/PrimeNFTFilter.sol#23) is a local variable never initialized
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#uninitialized-local-variables

ERC721._checkOnERC721Received(address,address,uint256,bytes) (lib/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol#399-421) ignores return value by IERC721Receiver(to).onERC721Received(_msgSender(),from,tokenId,data) (lib/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol#406-417)
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#unused-return

Ownable2Step.transferOwnership(address).newOwner (lib/openzeppelin-contracts/contracts/access/Ownable2Step.sol#35) lacks a zero-check on :
                - _pendingOwner = newOwner (lib/openzeppelin-contracts/contracts/access/Ownable2Step.sol#36)
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#missing-zero-address-validation

ERC721._checkOnERC721Received(address,address,uint256,bytes) (lib/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol#399-421) has external calls inside a loop: IERC721Receiver(to).onERC721Received(_msgSender(),from,tokenId,data) (lib/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol#406-417)
PrimeNFTFilter.findPrimeCount(address) (src/PrimeNFTFilter.sol#21-31) has external calls inside a loop: result = isPrime(nfttoken.tokenOfOwnerByIndex(owner,i)) (src/PrimeNFTFilter.sol#25)
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation/#calls-inside-a-loop

Variable 'ERC721._checkOnERC721Received(address,address,uint256,bytes).retval (lib/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol#406)' in ERC721._checkOnERC721Received(address,address,uint256,bytes) (lib/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol#399-421) potentially used before declaration: retval == IERC721Receiver.onERC721Received.selector (lib/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol#407)
Variable 'ERC721._checkOnERC721Received(address,address,uint256,bytes).reason (lib/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol#408)' in ERC721._checkOnERC721Received(address,address,uint256,bytes) (lib/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol#399-421) potentially used before declaration: reason.length == 0 (lib/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol#409)
Variable 'ERC721._checkOnERC721Received(address,address,uint256,bytes).reason (lib/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol#408)' in ERC721._checkOnERC721Received(address,address,uint256,bytes) (lib/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol#399-421) potentially used before declaration: revert(uint256,uint256)(32 + reason,mload(uint256)(reason)) (lib/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol#414)
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#pre-declaration-usage-of-local-variables

ERC721._checkOnERC721Received(address,address,uint256,bytes) (lib/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol#399-421) uses assembly
        - INLINE ASM (lib/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol#413-415)
Address._revert(bytes,string) (lib/openzeppelin-contracts/contracts/utils/Address.sol#231-243) uses assembly
        - INLINE ASM (lib/openzeppelin-contracts/contracts/utils/Address.sol#236-239)
Strings.toString(uint256) (lib/openzeppelin-contracts/contracts/utils/Strings.sol#19-39) uses assembly
        - INLINE ASM (lib/openzeppelin-contracts/contracts/utils/Strings.sol#25-27)
        - INLINE ASM (lib/openzeppelin-contracts/contracts/utils/Strings.sol#31-33)
Math.mulDiv(uint256,uint256,uint256) (lib/openzeppelin-contracts/contracts/utils/math/Math.sol#55-134) uses assembly
        - INLINE ASM (lib/openzeppelin-contracts/contracts/utils/math/Math.sol#62-66)
        - INLINE ASM (lib/openzeppelin-contracts/contracts/utils/math/Math.sol#85-92)
        - INLINE ASM (lib/openzeppelin-contracts/contracts/utils/math/Math.sol#99-108)
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#assembly-usage

Different versions of Solidity are used:
        - Version used: ['^0.8.0', '^0.8.1', '^0.8.13']
        - ^0.8.0 (lib/openzeppelin-contracts/contracts/access/Ownable.sol#4)
        - ^0.8.0 (lib/openzeppelin-contracts/contracts/access/Ownable2Step.sol#4)
        - ^0.8.0 (lib/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol#4)
        - ^0.8.0 (lib/openzeppelin-contracts/contracts/token/ERC721/IERC721.sol#4)
        - ^0.8.0 (lib/openzeppelin-contracts/contracts/token/ERC721/IERC721Receiver.sol#4)
        - ^0.8.0 (lib/openzeppelin-contracts/contracts/token/ERC721/extensions/ERC721Enumerable.sol#4)
        - ^0.8.0 (lib/openzeppelin-contracts/contracts/token/ERC721/extensions/IERC721Enumerable.sol#4)
        - ^0.8.0 (lib/openzeppelin-contracts/contracts/token/ERC721/extensions/IERC721Metadata.sol#4)
        - ^0.8.1 (lib/openzeppelin-contracts/contracts/utils/Address.sol#4)
        - ^0.8.0 (lib/openzeppelin-contracts/contracts/utils/Context.sol#4)
        - ^0.8.0 (lib/openzeppelin-contracts/contracts/utils/Strings.sol#4)
        - ^0.8.0 (lib/openzeppelin-contracts/contracts/utils/introspection/ERC165.sol#4)
        - ^0.8.0 (lib/openzeppelin-contracts/contracts/utils/introspection/IERC165.sol#4)
        - ^0.8.0 (lib/openzeppelin-contracts/contracts/utils/math/Math.sol#4)
        - ^0.8.0 (lib/openzeppelin-contracts/contracts/utils/math/SignedMath.sol#4)
        - ^0.8.13 (src/NFT.sol#2)
        - ^0.8.13 (src/PrimeNFTFilter.sol#2)
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#different-pragma-directives-are-used

ERC721Enumerable._removeTokenFromAllTokensEnumeration(uint256) (lib/openzeppelin-contracts/contracts/token/ERC721/extensions/ERC721Enumerable.sol#140-158) has costly operations inside a loop:
        - delete _allTokensIndex[tokenId] (lib/openzeppelin-contracts/contracts/token/ERC721/extensions/ERC721Enumerable.sol#156)
ERC721Enumerable._removeTokenFromAllTokensEnumeration(uint256) (lib/openzeppelin-contracts/contracts/token/ERC721/extensions/ERC721Enumerable.sol#140-158) has costly operations inside a loop:
        - _allTokens.pop() (lib/openzeppelin-contracts/contracts/token/ERC721/extensions/ERC721Enumerable.sol#157)
ERC721Enumerable._removeTokenFromOwnerEnumeration(address,uint256) (lib/openzeppelin-contracts/contracts/token/ERC721/extensions/ERC721Enumerable.sol#115-133) has costly operations inside a loop:
        - delete _ownedTokensIndex[tokenId] (lib/openzeppelin-contracts/contracts/token/ERC721/extensions/ERC721Enumerable.sol#131)
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#costly-operations-inside-a-loop

Pragma version^0.8.0 (lib/openzeppelin-contracts/contracts/access/Ownable.sol#4) allows old versions
Pragma version^0.8.0 (lib/openzeppelin-contracts/contracts/access/Ownable2Step.sol#4) allows old versions
Pragma version^0.8.0 (lib/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol#4) allows old versions
Pragma version^0.8.0 (lib/openzeppelin-contracts/contracts/token/ERC721/IERC721.sol#4) allows old versions
Pragma version^0.8.0 (lib/openzeppelin-contracts/contracts/token/ERC721/IERC721Receiver.sol#4) allows old versions
Pragma version^0.8.0 (lib/openzeppelin-contracts/contracts/token/ERC721/extensions/ERC721Enumerable.sol#4) allows old versions
Pragma version^0.8.0 (lib/openzeppelin-contracts/contracts/token/ERC721/extensions/IERC721Enumerable.sol#4) allows old versions
Pragma version^0.8.0 (lib/openzeppelin-contracts/contracts/token/ERC721/extensions/IERC721Metadata.sol#4) allows old versions
Pragma version^0.8.1 (lib/openzeppelin-contracts/contracts/utils/Address.sol#4) allows old versions
Pragma version^0.8.0 (lib/openzeppelin-contracts/contracts/utils/Context.sol#4) allows old versions
Pragma version^0.8.0 (lib/openzeppelin-contracts/contracts/utils/Strings.sol#4) allows old versions
Pragma version^0.8.0 (lib/openzeppelin-contracts/contracts/utils/introspection/ERC165.sol#4) allows old versions
Pragma version^0.8.0 (lib/openzeppelin-contracts/contracts/utils/introspection/IERC165.sol#4) allows old versions
Pragma version^0.8.0 (lib/openzeppelin-contracts/contracts/utils/math/Math.sol#4) allows old versions
Pragma version^0.8.0 (lib/openzeppelin-contracts/contracts/utils/math/SignedMath.sol#4) allows old versions
Pragma version^0.8.13 (src/NFT.sol#2) necessitates a version too recent to be trusted. Consider deploying with 0.6.12/0.7.6/0.8.7
Pragma version^0.8.13 (src/PrimeNFTFilter.sol#2) necessitates a version too recent to be trusted. Consider deploying with 0.6.12/0.7.6/0.8.7
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
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#low-level-calls

Function ERC721.__unsafe_increaseBalance(address,uint256) (lib/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol#463-465) is not in mixedCase
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#conformance-to-solidity-naming-conventions

renounceOwnership() should be declared external:
        - Ownable.renounceOwnership() (lib/openzeppelin-contracts/contracts/access/Ownable.sol#61-63)
transferOwnership(address) should be declared external:
        - Ownable.transferOwnership(address) (lib/openzeppelin-contracts/contracts/access/Ownable.sol#69-72)
        - Ownable2Step.transferOwnership(address) (lib/openzeppelin-contracts/contracts/access/Ownable2Step.sol#35-38)
acceptOwnership() should be declared external:
        - Ownable2Step.acceptOwnership() (lib/openzeppelin-contracts/contracts/access/Ownable2Step.sol#52-56)
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
tokenOfOwnerByIndex(address,uint256) should be declared external:
        - ERC721Enumerable.tokenOfOwnerByIndex(address,uint256) (lib/openzeppelin-contracts/contracts/token/ERC721/extensions/ERC721Enumerable.sol#37-40)
tokenByIndex(uint256) should be declared external:
        - ERC721Enumerable.tokenByIndex(uint256) (lib/openzeppelin-contracts/contracts/token/ERC721/extensions/ERC721Enumerable.sol#52-55)
mint(address,uint256[]) should be declared external:
        - NFT.mint(address,uint256[]) (src/NFT.sol#13-21)
findPrimeCount(address) should be declared external:
        - PrimeNFTFilter.findPrimeCount(address) (src/PrimeNFTFilter.sol#21-31)
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#public-function-that-could-be-declared-external
. analyzed (17 contracts with 78 detectors), 61 result(s) found
```