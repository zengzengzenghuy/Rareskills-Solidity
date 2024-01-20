## Contracts

- [ ] **Solidity contract 1:** Token with sanctions. Create a fungible token that allows an admin to ban specified addresses from sending and receiving tokens.
- [ ] **Solidity contract 2:** Token with god mode. A special address is able to transfer tokens between addresses at will.
- [ ] **Solidity contract 3:** (****\*\*\*\*****hard****\*\*\*\*****) Token sale and buyback with bonding curve. The more tokens a user buys, the more expensive the token becomes. To keep things simple, use a linear bonding curve.
  - [ ] Consider the case someone might [sandwhich attack](https://medium.com/coinmonks/defi-sandwich-attack-explain-776f6f43b2fd) a bonding curve. What can you do about it?
- [ ] **Solidity contract 4: (hard)** Untrusted escrow. Create a contract where a buyer can put an ********\*\*********arbitrary********\*\********* ERC20 token into a contract and a seller can withdraw it 3 days later. Based on your readings above, what issues do you need to defend against? Create the safest version of this that you can while guarding against issues that you cannot control. Does your contract handle fee-on transfer tokens or non-standard ERC20 tokens.

Foundry consists of:

- **Forge**: Ethereum testing framework (like Truffle, Hardhat and DappTools).
- **Cast**: Swiss army knife for interacting with EVM smart contracts, sending transactions and getting chain data.
- **Anvil**: Local Ethereum node, akin to Ganache, Hardhat Network.
- **Chisel**: Fast, utilitarian, and verbose solidity REPL.

## Documentation

https://book.getfoundry.sh/

## Usage

### Build

```shell
$ forge build
```

### Test

```shell
$ forge test
```

### Format

```shell
$ forge fmt
```

### Gas Snapshots

```shell
$ forge snapshot
```

### Anvil

```shell
$ anvil
```

### Deploy

```shell
$ forge script script/Counter.s.sol:CounterScript --rpc-url <your_rpc_url> --private-key <your_private_key>
```

### Cast

```shell
$ cast <subcommand>
```

### Help

```shell
$ forge --help
$ anvil --help
$ cast --help
```
