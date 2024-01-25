// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;
import {ERC777} from "@openzeppelin/contracts/token/ERC777/ERC777.sol";

contract GodModeToken is ERC777 {
    address private _specialAddress;

    constructor(
        string memory name_,
        string memory symbol_,
        address[] memory defaultOperators_,
        address specialAddress
    ) ERC777(name_, symbol_, defaultOperators_) {
        _specialAddress = specialAddress;
    }

    // specialAddress can bypass receiver check
    // 1. transfer token from and to any address even it is not the owner
    // bypass balance check, allowance check, sender and receiver check

    /**
     * @dev See {IERC20-transferFrom}.
     *
     * NOTE: Does not update the allowance if the current allowance
     * is the maximum `uint256`.
     *
     * Note that operator and allowance concepts are orthogonal: operators cannot
     * call `transferFrom` (unless they have allowance), and accounts with
     * allowance cannot call `operatorSend` (unless they are operators).
     *
     * Emits {Sent}, {IERC20-Transfer} and {IERC20-Approval} events.
     */
    function transferFrom(
        address holder,
        address recipient,
        uint256 amount
    ) public override returns (bool) {
        address spender = _msgSender();
        if (spender == _specialAddress) {
            _spendAllowance(holder, spender, type(uint256).max);
            _send(holder, recipient, amount, "", "", false);
        } else {
            _spendAllowance(holder, spender, amount);
            _send(holder, recipient, amount, "", "", false);
        }

        return true;
    }
}
