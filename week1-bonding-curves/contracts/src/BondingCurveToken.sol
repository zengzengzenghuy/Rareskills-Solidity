// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

/// @title BondingCurveToken contract with linear curve y = x
/// @author zeng
/// @dev Buy BondingCurveToken with ETH, token price(y) is equal to totalSupply(x)
/// @dev cool down time is added to prevent sandwich attack
contract BondingCurveToken is ERC20 {
    uint256 constant COOLDOWNTIME = 10 * 3600; //10 minutes
    mapping(address owner => uint256 buyTime) lastBuyTime;

    event BondingCurveTokenMinted(
        address indexed buyer,
        uint256 indexed tokenAmountMinted,
        uint256 indexed etherPaid
    );

    event BondingCurveTokenSold(
        address indexed seller,
        uint256 indexed tokenAmountBurnt,
        uint256 indexed etherReturn
    );

    constructor(
        string memory name_,
        string memory symbol_
    ) ERC20(name_, symbol_) {}


    /// @notice buy bc token
    /// @param amountToBuy amount of bc token to buy
    function buyToken(uint256 amountToBuy) public payable {
        uint256 totalPay = calculateBuyToken(amountToBuy);
        require(msg.value >= totalPay, "not enough ether to buy token");
        lastBuyTime[msg.sender] = block.timestamp;

        _mint(msg.sender, amountToBuy);
        emit BondingCurveTokenMinted(msg.sender, amountToBuy, msg.value);
    }

    /// @notice sell bc token
    /// @param amountToSell amount of bc token to sell
    function sellToken(uint256 amountToSell) public {
        require(
            block.timestamp >= lastBuyTime[msg.sender] + COOLDOWNTIME,
            "must wait for cool down time to sell token!"
        );

        uint256 returnEthAmountInWei = calculateSellToken(amountToSell);
        uint256 returnEthAmount = returnEthAmountInWei * 10 ** 18;
        _burn(msg.sender, amountToSell);
        payable(msg.sender).transfer(returnEthAmount);
        emit BondingCurveTokenSold(msg.sender, amountToSell, returnEthAmount);
    }

        /// @notice calculate the amount of ether to pay given amount of token to buy
    /// @dev total amount to pay = midpoint of total price * total amount of token to buy
    /// @param amountToBuy total amount of bonding curve token to buy
    /// @return total amount of ether has to pay
    function calculateBuyToken(
        uint256 amountToBuy
    ) internal view returns (uint256) {
        require(amountToBuy != 0, "cannot buy 0 token");

        uint256 startingPrice = totalSupply() + 1;
        uint256 endingPrice = totalSupply() + amountToBuy;
        uint256 totalPay = ((startingPrice + endingPrice) * amountToBuy) / 2;

        return totalPay;
    }

    /// @notice calculate the amount of ether to receive given amount of token to sell
    /// @dev total amount to receive = midpoint of total price * total amount of token to sell
    /// @param amountToSell total amount of bonding curve token to sell
    /// @return total amount of ether has to receive
    function calculateSellToken(
        uint256 amountToSell
    ) internal view returns (uint256) {
        require(amountToSell != 0, "cannot sell 0 token");
        uint256 startingPrice = totalSupply();
        require(amountToSell <= startingPrice, "not enough token to sell");
        uint256 endingPrice = totalSupply() - amountToSell + 1;
        uint256 totalReturn = ((startingPrice + endingPrice) * amountToSell) /
            2;
        return totalReturn;
    }

}
