// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

/// @title SanctionsToken blacklist certain addresses from transferring and receiving the token
/// @author zeng
contract SanctionsToken is ERC20 {
    using SafeERC20 for ERC20;
    address private _admin;

    mapping(address blackListedAddress => bool isBlackListed)
        private _isBlackListedAddress;

    event AdminSet(address indexed newAdmin);
    event AddressBlacklisted(address indexed blackListedAddress);

    constructor(
        string memory name_,
        string memory symbol_,
        address admin_
    ) ERC20(name_, symbol_) {
        _admin = admin_;
    }

    modifier onlyAdmin() {
        require(msg.sender == _admin, "msg.sender is not admin");
        _;
    }

    function setAdmin(address admin) external onlyAdmin {
        require(admin != address(0), "invalid address");
        require(admin != _admin, "duplicate admin address");

        emit AdminSet(admin);
        _admin = admin;
    }

    function blackListaddress(
        address[] calldata blackListAddress_
    ) external onlyAdmin {
        for (uint256 i = 0; i < blackListAddress_.length; ) {
            _isBlackListedAddress[blackListAddress_[i]] = true;

            emit AddressBlacklisted(blackListAddress_[i]);
            unchecked {
                ++i;
            }
        }
    }

    function transfer(
        address to,
        uint256 value
    ) public override returns (bool) {
        require(
            !_isBlackListedAddress[msg.sender],
            "msg.sender is blacklisted"
        );
        require(!_isBlackListedAddress[to], "recipient is blacklisted");
        return super.transfer(to, value);
    }

    function transferFrom(
        address from,
        address to,
        uint256 value
    ) public override returns (bool) {
        require(!_isBlackListedAddress[from], "msg.sender is blacklisted");
        require(!_isBlackListedAddress[to], "recipient is blacklisted");

        return super.transferFrom(from, to, value);
    }

    function mint(address account, uint256 amount) external onlyAdmin {
        require(account != address(0), "cannot mint to 0 address");
        require(amount != 0, "mint nothing");
        _mint(account, amount);
    }

    function burn(address account, uint256 amount) external onlyAdmin {
        require(account != address(0), "cannot mint to 0 address");
        require(amount != 0, "mint nothing");
        _burn(account, amount);
    }
}
