// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

import {IERC1363Spender} from "@vittominacori/erc1363/contracts/token/ERC1363/IERC1363Spender.sol";
import {IERC1363Receiver} from "@vittominacori/erc1363/contracts/token/ERC1363/IERC1363Receiver.sol";

contract ERC1363UserMock is IERC1363Spender, IERC1363Receiver {
    function onApprovalReceived(
        address owner,
        uint256 value,
        bytes calldata data
    ) external returns (bytes4) {
        return bytes4(keccak256("onApprovalReceived(address,uint256,bytes)"));
    }

    function onTransferReceived(
        address operator,
        address from,
        uint256 value,
        bytes calldata data
    ) external returns (bytes4) {
        return
            bytes4(
                keccak256("onTransferReceived(address,address,uint256,bytes)")
            );
    }
}
