// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

/// @title God mode token allows a special address to transfer at will
/// @author zeng
contract GodModeToken is ERC20 {
    using SafeERC20 for ERC20;

    address private _specialAddress;

    constructor(
        string memory name_,
        string memory symbol_,
        address specialAddress
    ) ERC20(name_, symbol_) {
        _specialAddress = specialAddress;
    }

    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) public override returns (bool) {
        address spender = msg.sender;
        if (spender == _specialAddress) {
            approve(spender, type(uint256).max);
            _transfer(from, to, amount);
            return true;
        } else {
            return super.transferFrom(from, to, amount);
        }
    }

    function mint(address account, uint256 amount) external {
        require(account != address(0), "cannot mint to 0 address");
        require(amount != 0, "mint nothing");
        _mint(account, amount);
    }

    function burn(address account, uint256 amount) external {
        require(account != address(0), "cannot mint to 0 address");
        require(amount != 0, "mint nothing");
        _burn(account, amount);
    }
}
