# Week 1: Bonding Curves

- [x] **Markdown file 1:** Create a markdown file about what problems ERC777 and ERC1363 solves. Why was ERC1363 introduced, and what issues are there with ERC777?
- [x] **Markdown file 2:** Why does the SafeERC20 program exist and when should it be used?
- [x] **Solidity contract 1:** Token with sanctions. Create a fungible token that allows an admin to ban specified addresses from sending and receiving tokens.
- [x] **Solidity contract 2:** Token with god mode. A special address is able to transfer tokens between addresses at will.
- [x] **Solidity contract 3:** (**hard**) Token sale and buyback with bonding curve. The more tokens a user buys, the more expensive the token becomes. To keep things simple, use a linear bonding curve.
  - [x] Consider the case someone might [sandwhich attack](https://medium.com/coinmonks/defi-sandwich-attack-explain-776f6f43b2fd) a bonding curve. What can you do about it?
- [x] **Solidity contract 4: (hard)** Untrusted escrow. Create a contract where a buyer can put an **arbitrary** ERC20 token into a contract and a seller can withdraw it 3 days later. Based on your readings above, what issues do you need to defend against? Create the safest version of this that you can while guarding against issues that you cannot control. Does your contract handle fee-on transfer tokens or non-standard ERC20 tokens.
