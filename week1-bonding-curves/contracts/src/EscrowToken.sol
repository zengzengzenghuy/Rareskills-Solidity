// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

interface ERC777TokensSender {
    function tokensToSend(
        address operator,
        address from,
        address to,
        uint256 amount,
        bytes calldata userData,
        bytes calldata operatorData
    ) external;
}

interface ERC777TokensRecipient {
    function tokensReceived(
        address operator,
        address from,
        address to,
        uint256 amount,
        bytes calldata data,
        bytes calldata operatorData
    ) external;
}

interface ERC1363Receiver {
    /*
     * Note: the ERC-165 identifier for this interface is 0x88a7ca5c.
     * 0x88a7ca5c === bytes4(keccak256("onTransferReceived(address,address,uint256,bytes)"))
     */

    /**
     * @notice Handle the receipt of ERC1363 tokens
     * @dev Any ERC1363 smart contract calls this function on the recipient
     * after a `transfer` or a `transferFrom`. This function MAY throw to revert and reject the
     * transfer. Return of other than the magic value MUST result in the
     * transaction being reverted.
     * Note: the token contract address is always the message sender.
     * @param operator address The address which called `transferAndCall` or `transferFromAndCall` function
     * @param from address The address which are token transferred from
     * @param value uint256 The amount of tokens transferred
     * @param data bytes Additional data with no specified format
     * @return `bytes4(keccak256("onTransferReceived(address,address,uint256,bytes)"))`
     *  unless throwing
     */

    function onTransferReceived(
        address operator,
        address from,
        uint256 value,
        bytes memory data
    ) external returns (bytes4);
}

interface ERC1363Spender {
    /*
     * Note: the ERC-165 identifier for this interface is 0x7b04a2d0.
     * 0x7b04a2d0 === bytes4(keccak256("onApprovalReceived(address,uint256,bytes)"))
     */

    /**
     * @notice Handle the approval of ERC1363 tokens
     * @dev Any ERC1363 smart contract calls this function on the recipient
     * after an `approve`. This function MAY throw to revert and reject the
     * approval. Return of other than the magic value MUST result in the
     * transaction being reverted.
     * Note: the token contract address is always the message sender.
     * @param owner address The address which called `approveAndCall` function
     * @param value uint256 The amount of tokens to be spent
     * @param data bytes Additional data with no specified format
     * @return `bytes4(keccak256("onApprovalReceived(address,uint256,bytes)"))`
     *  unless throwing
     */
    function onApprovalReceived(
        address owner,
        uint256 value,
        bytes memory data
    ) external returns (bytes4);
}

contract EscrowToken {
    // allows different standard of ERC20
    // ERC777
    // ERC1363
    // check if this contract has allowance from buyer
    // check time is 3 days
    // check if approve or transfer

    struct Deal {
        uint256 amount;
        uint256 depositTime;
        address token;
    }
    event dealOpen(
        address indexed buyer,
        address indexed seller,
        uint256 amount
    );

    event dealClosed(
        address indexed buyer,
        address indexed seller,
        uint256 amount,
        uint256 time
    );
    IERC20 erc20;
    mapping(address buyer => mapping(address seller => Deal deal)) dealDetails;

    // TODO: use ERC1820 registry to check the token standard
    function depositToken(
        address seller,
        uint256 amount,
        address token
    ) public {
        erc20 = IERC20(token);
        erc20.transferFrom(msg.sender, address(this), amount);
        dealDetails[msg.sender][seller] = Deal(amount, block.timestamp, token);
        emit dealOpen(msg.sender, seller, amount);
        delete erc20;
    }

    function withdrawToken(address buyer) public {
        uint256 tokenToWithdraw = dealDetails[buyer][msg.sender].amount;
        require(tokenToWithdraw != 0, "No deal!");
        require(
            block.timestamp >=
                dealDetails[buyer][msg.sender].depositTime + 3 days,
            "seller has to wait 3 days to withdraw!"
        );

        erc20 = IERC20(dealDetails[buyer][msg.sender].token);
        erc20.transferFrom(address(this), msg.sender, tokenToWithdraw);
        emit dealClosed(buyer, msg.sender, tokenToWithdraw, block.timestamp);
        dealDetails[buyer][msg.sender] = Deal(0, 0, address(0));
    }
}
