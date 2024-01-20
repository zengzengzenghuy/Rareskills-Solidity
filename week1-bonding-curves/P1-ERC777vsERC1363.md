# What problems ERC777 and ERC1363 solves.

Both token standards solve the issue of ERC20, where it is not possible to execute code after `transfer`, `transferFrom`, and `approve`.

Additional condition checks can be made before transferring or receiving tokens. The receiver can revert if the token is not registered, which solves the problem of dummy ERC20 tokens getting sent to the user's address.

In ERC777, a hook is a function call that will be executed for the sender and receiver. Specifically, the `tokensToSend` hook from the sender will be called before updating the balance state, and the `tokensReceive` hook from the receiver will be called after updating the balance state.

In ERC1363, `transferAndCall` and `transferFromAndCall` will call the receiver's hook after the transfer is made. Meanwhile, `approveAndCall` will call the spender's hook before the transfer is made.

# Why was ERC1363 introduced, and what issues are there with ERC777?

ERC1363 was introduced to enable function calls and condition checks before or after a token transfer.

ERC777 can cause a reentrancy attack because an attacker can execute malicious code before the ERC777 token updates the balance state. Specifically, the attacker can call the same transfer function again while the state in the token contract still persists with the old state before the function call.
