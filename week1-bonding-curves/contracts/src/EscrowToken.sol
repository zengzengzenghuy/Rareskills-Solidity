// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {ERC777} from "@openzeppelin/contracts/token/ERC777/ERC777.sol";
import {IERC1363} from "@vittominacori/erc1363/contracts/token/ERC1363/IERC1363.sol";

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
    function onTransferReceived(
        address operator,
        address from,
        uint256 value,
        bytes memory data
    ) external returns (bytes4);
}

interface ERC1363Spender {
    function onApprovalReceived(
        address owner,
        uint256 value,
        bytes memory data
    ) external returns (bytes4);
}

/// @title A title that should describe the contract/interface
/// @author The name of the author
/// @notice Explain to an end user what this does
/// @dev Explain to a developer any extra details
contract EscrowToken is
    ERC777TokensRecipient,
    ERC777TokensSender,
    ERC1363Receiver,
    ERC1363Spender
{

    IERC20 erc20;
    ERC777 erc777;
    IERC1363 erc1363;

    mapping(address buyer => mapping(address seller => Deal deal)) dealDetails;
    error UnsupportedTokenType();

    struct Deal {
        uint256 amount;
        uint256 depositTime;
        address token;
        uint8 tokenType; // 0: ERC20, 1: ERC777, 2: ERC1363
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

    /// @notice deposit token from buyer
    /// @dev call different type of transfer based on token type
    /// @param seller the seller that buyer(msg.sender) want to buy from
    /// @param amount amount of token to deposit
    /// @param token token address
    /// @param tokenType tokenType: 0 = ERC20, 1 = ERC777, 2 = ERC1363
    function depositToken(
        address seller,
        uint256 amount,
        address token,
        uint8 tokenType
    ) external {
        require(seller != address(0), "invalid seller address");
        require(amount != 0, "amount cannot be 0");
        require(token != address(0), "invalid token address");

        if (tokenType == 0) {
            erc20 = IERC20(token);
            erc20.transferFrom(msg.sender, address(this), amount);
            dealDetails[msg.sender][seller] = Deal(
                amount,
                block.timestamp,
                token,
                tokenType
            );
            emit dealOpen(msg.sender, seller, amount);
            delete erc20;
        } else if (tokenType == 1) {
            erc777 = ERC777(token);
            erc777.transferFrom(msg.sender, address(this), amount);
            dealDetails[msg.sender][seller] = Deal(
                amount,
                block.timestamp,
                token,
                tokenType
            );
            emit dealOpen(msg.sender, seller, amount);
            delete erc777;
        } else if (tokenType == 2) {
            erc1363 = IERC1363(token);
            erc1363.transferFromAndCall(msg.sender, address(this), amount);
            dealDetails[msg.sender][seller] = Deal(
                amount,
                block.timestamp,
                token,
                tokenType
            );
            emit dealOpen(msg.sender, seller, amount);
            delete erc1363;
        } else {
            revert UnsupportedTokenType();
        }
    }

    /// @notice withdraw token from buyer
    /// @dev seller withdraw token deposited from buyer, only called by valid seller
    /// @param buyer buyer from the deal
    function withdrawToken(address buyer) external {
        uint256 tokenToWithdraw = dealDetails[buyer][msg.sender].amount;
        address token = dealDetails[buyer][msg.sender].token;
        require(tokenToWithdraw != 0, "No deal!");
        require(
            block.timestamp >=
                dealDetails[buyer][msg.sender].depositTime + 3 days,
            "seller has to wait 3 days to withdraw!"
        );
        uint8 tokenType = dealDetails[buyer][msg.sender].tokenType;

        if (tokenType == 0) {
            erc20 = IERC20(token);
            erc20.transfer(msg.sender, tokenToWithdraw);
            emit dealClosed(
                buyer,
                msg.sender,
                tokenToWithdraw,
                block.timestamp
            );
            dealDetails[buyer][msg.sender] = Deal(0, 0, address(0), 0);
        } else if (tokenType == 1) {
            erc777 = ERC777(token);
            erc777.transfer(msg.sender, tokenToWithdraw);
            emit dealClosed(
                buyer,
                msg.sender,
                tokenToWithdraw,
                block.timestamp
            );
            dealDetails[buyer][msg.sender] = Deal(0, 0, address(0), 0);
        } else if (tokenType == 2) {
            erc1363 = IERC1363(token);
            erc1363.transferAndCall(msg.sender, tokenToWithdraw);

            emit dealClosed(
                buyer,
                msg.sender,
                tokenToWithdraw,
                block.timestamp
            );
            dealDetails[buyer][msg.sender] = Deal(0, 0, address(0), 0);
        }
    }

    /// @inheritdoc ERC777TokensRecipient
    function tokensReceived(
        address operator,
        address from,
        address to,
        uint256 amount,
        bytes calldata data,
        bytes calldata operatorData
    ) external {
        require(amount != 0, "empty amount!");
        require(from != address(0), "invalid from address");
        require(to != address(0), "invalid receipient address");
    }

    /// @inheritdoc ERC777TokensSender
    function tokensToSend(
        address operator,
        address from,
        address to,
        uint256 amount,
        bytes calldata userData,
        bytes calldata operatorData
    ) external {
        require(amount != 0, "empty amount!");
        require(from != address(0), "invalid from address");
        require(to != address(0), "invalid receipient address");
    }

    /// @inheritdoc ERC1363Receiver
    function onTransferReceived(
        address operator,
        address from,
        uint256 value,
        bytes memory data
    ) external returns (bytes4) {
        require(value != 0, "empty amount!");
        require(from != address(0), "invalid from address");

        return
            bytes4(
                keccak256("onTransferReceived(address,address,uint256,bytes)")
            );
    }

    /// @inheritdoc ERC1363Spender
    function onApprovalReceived(
        address owner,
        uint256 value,
        bytes memory data
    ) external returns (bytes4) {
        require(value != 0, "empty amount!");
        require(owner != address(0), "invalid owner address");
        return bytes4(keccak256("onApprovalReceived(address,uint256,bytes)"));
    }
}
