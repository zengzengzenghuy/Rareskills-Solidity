pragma solidity ^0.8.0;

//import './interfaces/IUniswapV2ERC20.sol';
import "solady/tokens/ERC20.sol";


contract UniswapV2ERC20 is ERC20 {

 

    string public constant tokenName = 'Uniswap V2';
    string public constant tokenSymbol = 'UNI-V2';
    // already in ERC20
    // uint8 public constant decimals = 18;
    // already in ERC20
    // uint  public totalSupply;

    // keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
    bytes32 public constant PERMIT_TYPEHASH = 0x6e71edae12b1b97f4d1f60370fef10105fa2faae0126114a169c64845d6126c9;

    function _constantNameHash() internal pure override returns (bytes32 result) {
        return keccak256(bytes(tokenName));
    }


    function name() public pure override returns (string memory){
      return tokenName;
    }

    function symbol() public pure override returns (string memory){
        return tokenSymbol;
    }

 

    // function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external {
    //     require(deadline >= block.timestamp, 'UniswapV2: EXPIRED');
    //     bytes32 digest = keccak256(
    //         abi.encodePacked(
    //             '\x19\x01',
    //             DOMAIN_SEPARATOR,
    //             keccak256(abi.encode(PERMIT_TYPEHASH, owner, spender, value, nonces[owner]++, deadline))
    //         )
    //     );
    //     address recoveredAddress = ecrecover(digest, v, r, s);
    //     require(recoveredAddress != address(0) && recoveredAddress == owner, 'UniswapV2: INVALID_SIGNATURE');
    //     _approve(owner, spender, value);
    // }
}
