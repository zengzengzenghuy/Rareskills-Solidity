// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

import {IERC777Recipient} from "@openzeppelin/contracts/token/ERC777/IERC777Recipient.sol";
import {IERC777Sender} from "@openzeppelin/contracts/token/ERC777/IERC777Sender.sol";

/// @dev The interface a contract MUST implement if it is the implementer of
/// some (other) interface for any address other than itself.
interface ERC1820ImplementerInterface {
    /// @notice Indicates whether the contract implements the interface 'interfaceHash' for the address 'addr' or not.
    /// @param interfaceHash keccak256 hash of the name of the interface
    /// @param addr Address for which the contract will implement the interface
    /// @return ERC1820_ACCEPT_MAGIC only if the contract implements 'interfaceHash' for the address 'addr'.
    function canImplementInterfaceForAddress(
        bytes32 interfaceHash,
        address addr
    ) external view returns (bytes32);
}

contract ERC777UserMock is
    IERC777Recipient,
    IERC777Sender,
    ERC1820ImplementerInterface
{
    bytes32 internal constant ERC1820_ACCEPT_MAGIC =
        keccak256(abi.encodePacked("ERC1820_ACCEPT_MAGIC"));
    event TokenReceived(address indexed sender, uint256 indexed amount);
    event TokenSent(address indexed recipient, uint256 indexed amount);

    function tokensReceived(
        address operator,
        address from,
        address to,
        uint256 amount,
        bytes calldata userData,
        bytes calldata operatorData
    ) external {
        emit TokenReceived(msg.sender, amount);
    }

    function tokensToSend(
        address operator,
        address from,
        address to,
        uint256 amount,
        bytes calldata userData,
        bytes calldata operatorData
    ) external {
        emit TokenSent(to, amount);
    }

    function canImplementInterfaceForAddress(
        bytes32 /*interfaceHash*/,
        address /*addr*/
    ) external view returns (bytes32) {
        return ERC1820_ACCEPT_MAGIC;
    }
}
