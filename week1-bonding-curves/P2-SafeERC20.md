# Why does the SafeERC20 program exist and when should it be used?

SafeERC20 program exists to solve the issue that ERC20 `transfer` or `transferFrom` return a boolean and do not revert. We need to check the return boolean value to make sure the call the success or not. SafeERC20 does the return check for developers by implementing the low level call in Solidity to bypass Solidity's return data size checking mechanism.
