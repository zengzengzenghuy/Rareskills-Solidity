// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Dex.sol";


contract Test {
    Dex dex;
    SwappableToken token1;
    SwappableToken token2;
    address echidna = msg.sender;

    constructor() {
        dex = new Dex();
        token1 = new SwappableToken(address(dex),"token1","tk1",110);
        token2 = new SwappableToken(address(dex),"token2","tk2",110);
        dex.setTokens(address(token1),address(token2));

        token1.approve(address(dex),100);
        token2.approve(address(dex),100);
        dex.addLiquidity(address(token1),100);
        dex.addLiquidity(address(token2), 100);

        token1.transfer(echidna,10);
        token2.transfer(echidna,10);
        dex.transferOwnership(address(0x1));
    

    }
   function echidna_test_balance() public view returns(bool) {
 
    return  token1.balanceOf(address(dex)) == 0 ||  token2.balanceOf(address(dex)) == 0 ;
   }
}