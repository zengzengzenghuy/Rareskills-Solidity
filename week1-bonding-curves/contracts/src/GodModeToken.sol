// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";


/// @title GodModeToken allows a special address to transfer tokens between addresses at will
/// @author zeng
/// @dev is ERC20 token, with a specialAddress to have unlimited allowance to transfer token at will 
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

    /// @notice transfer token from `from` to `to`
    /// @dev ERC20 transferFrom with specialAddress check, specialAddress have max allowance from spender
    /// @param from address to transfer the token from
    /// @param to address to transfer the token to
    /// @param amount amount of token to transfer from `from` to `to`
    /// @return indicate whether the transfer is success or fail
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

    /// @notice mint token to account
    /// @dev mint `amount` of token to `account`
    /// @param account account to mint to
    /// @param amount amount of token to mint to the account
    function mint(address account, uint256 amount) external {
        require(account != address(0), "cannot mint to 0 address");
        require(amount != 0, "mint nothing");
        _mint(account, amount);
    }

    /// @notice burn token from account
    /// @dev burn `amount` of token from `account`
    /// @param account account to burn from
    /// @param amount amount of token to burn from the account
    function burn(address account, uint256 amount) external {
        require(account != address(0), "cannot mint to 0 address");
        require(amount != 0, "mint nothing");
        _burn(account, amount);
    }
}
