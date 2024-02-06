// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;
import {BancorFormula} from "./utils/BancorFormula.sol";
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract BondingCurveToken is BancorFormula, ERC20 {
    uint256 public reserveRatio;
    uint256 public reserveAmount = 10;
    uint256 constant MAXRESERVERATIO = 100;
    IERC20 ReserveToken;
    uint256 constant COOLDOWNTIME = 10 * 3600; // 10 minutes

    mapping(address owner => uint256 buyTime) lastBuyTime;

    event BondingCurveTokenMinted(
        address indexed buyer,
        uint256 tokenAmountMinted,
        uint256 reservePaid
    );

    event BondingCurveTokenSold(
        address indexed seller,
        uint256 tokenAmountBurnt,
        uint256 reserveReturn
    );

    constructor(
        string memory name_,
        string memory symbol_,
        uint256 reserveRatio_,
        address reserveToken_
    ) ERC20(name_, symbol_) {
        reserveRatio = reserveRatio_;
        _mint(msg.sender, 10);
        ReserveToken = IERC20(reserveToken_);
    }

    function buyToken(uint256 amountToPay) public {
        uint256 tokenAmount = buyContinuousToken(
            reserveRatio,
            amountToPay,
            totalSupply(),
            reserveAmount
        );

        _mint(msg.sender, tokenAmount);
        //ReserveToken.approve(address(this), amountToPay);
        ReserveToken.transferFrom(msg.sender, address(this), amountToPay);
        reserveAmount += amountToPay;
        emit BondingCurveTokenMinted(msg.sender, tokenAmount, amountToPay);
        lastBuyTime[msg.sender] = block.timestamp;
    }

    function sellToken(uint256 amountToSell) public {
        require(
            block.timestamp >= lastBuyTime[msg.sender] + COOLDOWNTIME,
            "must wait for cool down time!"
        );
        uint256 tokenAmount = sellContinuousToken(
            reserveRatio,
            amountToSell,
            totalSupply(),
            reserveAmount
        );

        _burn(msg.sender, amountToSell);
        ReserveToken.transfer(msg.sender, tokenAmount);
        reserveAmount -= tokenAmount;
        emit BondingCurveTokenSold(msg.sender, amountToSell, tokenAmount);
    }

    function transfer(
        address to,
        uint256 value
    ) public override returns (bool) {
        // require(
        //     block.timestamp >= lastBuyTime[msg.sender] + COOLDOWNTIME,
        //     "must wait for cool down time before transferring!"
        // );
        super.transfer(to, value);
        return true;
    }

    function transferFrom(
        address from,
        address to,
        uint256 value
    ) public override returns (bool) {
        // require(
        //     block.timestamp >= lastBuyTime[msg.sender] + COOLDOWNTIME,
        //     "must wait for cool down time before transferring!"
        // );
        super.transferFrom(from, to, value);
        return true;
    }
}
