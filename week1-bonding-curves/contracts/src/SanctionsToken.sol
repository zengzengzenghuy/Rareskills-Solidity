// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

import {ERC777} from "@openzeppelin/contracts/token/ERC777/ERC777.sol";

contract SanctionsToken is ERC777 {
    constructor(
        string memory name_,
        string memory symbol_,
        address[] memory defaultOperators_
    ) ERC777(name_, symbol_, defaultOperators_) {}

    mapping(address blackListedAddress => bool isBlackListed)
        private _isBlackListedAddress;

    function blackListaddress(address[] calldata blackListAddress_) external {
        address[] memory defaultOperators = defaultOperators();
        bool isDefaultOperator = false;
        for (uint256 i = 0; i < defaultOperators.length; i++) {
            if (defaultOperators[i] == _msgSender()) {
                isDefaultOperator = true;
            }
        }
        require(isDefaultOperator, "caller is not default operator!");

        for (uint256 i = 0; i < blackListAddress_.length; i++) {
            _isBlackListedAddress[blackListAddress_[i]] = true;
        }
    }

    function send(
        address recipient,
        uint256 amount,
        bytes memory data
    ) public override {
        require(
            _isBlackListedAddress[msg.sender] == false,
            "sender is blacklisted!"
        );
        require(
            _isBlackListedAddress[recipient] == false,
            "recipient is blacklisted!"
        );
        _send(_msgSender(), recipient, amount, data, "", true);
    }

    function transfer(
        address recipient,
        uint256 amount
    ) public override returns (bool) {
        require(
            _isBlackListedAddress[msg.sender] == false,
            "sender is blacklisted!"
        );
        require(
            _isBlackListedAddress[recipient] == false,
            "recipient is blacklisted!"
        );
        _send(_msgSender(), recipient, amount, "", "", false);
        return true;
    }
}
