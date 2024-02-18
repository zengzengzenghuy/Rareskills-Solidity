# Week 3-5 Uniswap v2

- [ ]  Re-implement Uniswap V2 with the following requirements
- use solidity 0.8.0 or higher. **********************************************************You need to be conscious of when the original implementation originally intended to overflow in the oracle**********************************************************
- Use the Solady ERC20 library to accomplish the LP token, also use the Solady library to accomplish the square root
- The uniswap re-entrancy lock is not gas efficient anymore because of changes in the EVM
- Your code should have built-in safety checks for swap, mint, and burn. ********************************************************************************You should not assume people will use a router but instead directly interface with your contract********************************************************************************
- The swap function should not support flash swaps, you should build a separate flashloan function that is compliant with ERC-3156
- Don’t use safemath with 0.8.0 or higher
- You should only implement the factory and the pair (which inherits from ERC20), don’t implement other contracts
- [ ]  Write a markdown file explaining how to use the TWAP oracle with Uniswap V2. You need to answer the following questions:
    - Why does the `price0CumulativeLast` and `price1CumulativeLast` never decrement?
    - How do you write a contract that uses the oracle?
    - Why are `price0CumulativeLast` and `price1CumulativeLast` stored separately? Why not just calculate ``price1CumulativeLast = 1/price0CumulativeLast`?