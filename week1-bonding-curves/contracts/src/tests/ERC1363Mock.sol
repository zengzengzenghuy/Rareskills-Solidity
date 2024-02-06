// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

import {ERC1363} from "@vittominacori/erc1363/contracts/token/ERC1363/ERC1363.sol";

contract ERC1363Mock is ERC1363 {
    constructor(
        string memory name_,
        string memory symbol_
    ) ERC20(name_, symbol_) {}

    function mint(address recipient, uint256 amount) external {
        _mint(recipient, amount);
    }
}
