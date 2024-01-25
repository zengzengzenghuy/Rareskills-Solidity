// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

import {SafeMath} from "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract BancorFormula {
    using SafeMath for uint256;

    uint256 private constant _ONE = 1;

    function buyContinuousToken(
        uint256 reserveRatio,
        uint256 amountReservePaid,
        uint256 initialSupply,
        uint256 initialReserveToken
    ) public returns (uint256) {
        uint256 base = (amountReservePaid.add(initialReserveToken)).div(
            initialReserveToken
        );
        uint256 continuousTokenAmount = initialSupply.mul(
            power(base, reserveRatio)
        );

        require(
            continuousTokenAmount > 0,
            "Continuous Token amount should be positive!"
        );
        return continuousTokenAmount;
    }

    function sellContinuousToken(
        uint256 reserveRatio,
        uint256 amountContinuousPaid,
        uint256 initialSupply,
        uint256 intiialReserveToken
    ) public returns (uint256) {
        uint256 base = (initialSupply.sub(amountContinuousPaid)).div(
            initialSupply
        );
        uint256 x = _ONE.sub(power(base, _ONE.div(reserveRatio)));

        uint256 reserveTokenAmount = intiialReserveToken.mul(x);
        require(
            reserveTokenAmount > 0,
            "Reserve Token amount should be positive!"
        );
        return reserveTokenAmount;
    }

    function power(uint256 base, uint256 exp) public pure returns (uint256) {
        if (exp == 0) {
            return 1;
        } else if (exp == 1) {
            return base;
        } else {
            uint256 p = power(base, exp.div(2));
            p = p.mul(p);
            if (exp.mod(2) == 1) {
                p = p.mul(base);
            }
            return p;
        }
    }
}
