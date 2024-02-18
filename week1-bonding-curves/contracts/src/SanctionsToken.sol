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

  modifier onlyAdmin() {
        require(msg.sender == _admin, "msg.sender is not admin");
        _;
    }

    constructor(
        string memory name_,
        string memory symbol_,
        address admin_
    ) ERC20(name_, symbol_) {
        _admin = admin_;
    }

  
  /// @notice set admin
  /// @dev set new admin, only can be set by admin
  /// @param admin new admin address
    function setAdmin(address admin) external onlyAdmin {
        require(admin != address(0), "invalid address");
        require(admin != _admin, "duplicate admin address");

        emit AdminSet(admin);
        _admin = admin;
    }

/// @notice blacklist addresses
/// @dev set blacklisted addresses, only can be set by admin
/// @param blackListAddress_ an array of blacklist addresses
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

/// @notice mint token to account
/// @dev mint `amount` of token to `account`, only can mint by admin
/// @param account account to mint to
/// @param amount amount of token to mint to the account
   function mint(address account, uint256 amount) external onlyAdmin {
        require(account != address(0), "cannot mint to 0 address");
        require(amount != 0, "mint nothing");
        _mint(account, amount);
    }


/// @notice burn token from account
/// @dev burn `amount` of token from `account`, only can burn by admin
/// @param account account to burn from
/// @param amount amount of token to burn from the account
    function burn(address account, uint256 amount) external onlyAdmin {
        require(account != address(0), "cannot mint to 0 address");
        require(amount != 0, "mint nothing");
        _burn(account, amount);
    }

    /// @notice transfer token to account
    /// @dev transfer `amount` of token to `to`
    /// @param to address to transfer to
    /// @param amount amount of token to transfer to
    /// @return indicate whether the transfer is success or fail
    function transfer(
        address to,
        uint256 amount
    ) public override returns (bool) {
        require(
            !_isBlackListedAddress[msg.sender],
            "msg.sender is blacklisted"
        );
        require(!_isBlackListedAddress[to], "recipient is blacklisted");
        return super.transfer(to, amount);
    }

    /// @notice transfer token `from` to `to`
    /// @param from address to transfer from
    /// @param to address to transfer to
    /// @param amount amount of token to transfer from `from` to `to`
    /// @return indicate whether the transferFrom is success or fail
    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) public override returns (bool) {
        require(!_isBlackListedAddress[from], "msg.sender is blacklisted");
        require(!_isBlackListedAddress[to], "recipient is blacklisted");

        return super.transferFrom(from, to, amount);
    }

 
}
