pragma solidity ^0.8.0;

import './interfaces/IUniswapV2Pair.sol';
import './UniswapV2ERC20.sol';
import './libraries/Math.sol';
import './libraries/UQ112x112.sol';
import './interfaces/IERC20.sol';
import './interfaces/IUniswapV2Factory.sol';
import './interfaces/IUniswapV2Callee.sol';
import './interfaces/IERC3156FlashLender.sol';

import "solady/utils/ReentrancyGuard.sol";


contract UniswapV2PairNew is ReentrancyGuard, IERC3156FlashLender, UniswapV2ERC20 {
        using UQ112x112 for uint224;
        uint public constant MINIMUM_LIQUIDITY = 10**3;
        bytes4 private constant TRANSFER_SELECTOR = bytes4(keccak256(bytes('transfer(address,uint256)')));
                bytes4 private constant TRANSFERFROM_SELECTOR = bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));
        bytes32 public constant CALLBACK_SUCCESS = keccak256("ERC3156FlashBorrower.onFlashLoan");
        uint256 public flashLoanFee = 1; //  1 == 0.01 %.

        address public token0;
        address public token1;

        uint112 private reserve0;           // uses single storage slot, accessible via getReserves
        uint112 private reserve1;           // uses single storage slot, accessible via getReserves
        uint32  private blockTimestampLast; // uses single storage slot, accessible via getReserves


        uint public price0CumulativeLast;
        uint public price1CumulativeLast;
        uint public kLast; // reserve0 * reserve1, as of immediately after the most recent liquidity event

        event Mint(address indexed sender, uint amount0, uint amount1);
        event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
        event Swap(
            address indexed sender,
            uint amount0In,
            uint amount1In,
            uint amount0Out,
            uint amount1Out,
            address indexed to
        );
        event Sync(uint112 reserve0, uint112 reserve1);


        function getReserves() public view returns (uint112 _reserve0, uint112 _reserve1, uint32 _blockTimestampLast) {
        _reserve0 = reserve0;
        _reserve1 = reserve1;
        _blockTimestampLast = blockTimestampLast;

         }

        function _safeTransfer(address token, address to, uint value) private {
            (bool success, bytes memory data) = token.call(abi.encodeWithSelector(TRANSFER_SELECTOR, to, value));
            require(success && (data.length == 0 || abi.decode(data, (bool))), 'UniswapV2: TRANSFER_FAILED');
        }
        function _safeTransferFrom(address token, address from, address to, uint value) private {
            (bool success, bytes memory data) = token.call(abi.encodeWithSelector(TRANSFERFROM_SELECTOR, from, to, value));
            require(success && (data.length == 0 || abi.decode(data, (bool))), 'UniswapV2: TRANSFERFROM_FAILED');
        }

        function _update(uint balance0, uint balance1, uint112 reserve0, uint112 reserve1) internal {
            // update the price0Accumulate, price1Accumulate
                (uint112 reserve0, uint112 reserve1,) = getReserves();

            require(balance0 <= type(uint112).max && balance1 <= type(uint112).max,'Overflow!');
            uint32 blockTimestamp = uint32(block.timestamp % 2*32);
            uint timeElapsed = blockTimestamp - blockTimestampLast;
            if(timeElapsed > 0 && reserve0 !=0 && reserve1!=0 ){
                unchecked {
                    price0CumulativeLast += uint(UQ112x112.encode(reserve0).uqdiv(reserve1)) * timeElapsed;
                    price1CumulativeLast += uint(UQ112x112.encode(reserve0).uqdiv(reserve1)) * timeElapsed;
                }
            }
            reserve0 = uint112(balance0);
            reserve1 = uint112(balance1);
            blockTimestampLast = blockTimestamp;
            emit Sync(reserve0, reserve1);

        }

        // remove mintFee function
        

        function mint(address to, uint minLPToken) public nonReentrant returns (uint liquidity){
            (uint112 reserve0, uint112 reserve1,) = getReserves();

            uint balance0 = IERC20(token0).balanceOf(address(this));
            uint balance1 = IERC20(token1).balanceOf(address(this));

            uint amount0In = balance0 - reserve0;
            uint amount1In = balance1 - reserve1;
            uint _totalSupply = totalSupply();
            if(_totalSupply==0){
                liquidity = Math.sqrt(amount0In * amount1In) - MINIMUM_LIQUIDITY;
        
                _mint(address(0), liquidity);
            }else {
                liquidity = Math.min(amount0In*_totalSupply/reserve0, amount1In*_totalSupply/reserve1);

            }
            require(liquidity >= minLPToken, 'LP token insufficient');
            _mint(to, liquidity);

   
            _update(balance0,balance1,reserve0,reserve1);
            kLast = Math.sqrt(reserve0 * reserve1);
            emit Mint(msg.sender, amount0In, amount1In);
        }

        function addLiquidity(address LPTokenReceiver, uint minLPToken, uint amount0In, uint amount1In) external nonReentrant {

            _safeTransferFrom(token0, msg.sender, address(this),amount0In);
            _safeTransferFrom(token1, msg.sender, address(this), amount1In);
            mint(LPTokenReceiver, minLPToken);

        }


        function removeLiquidity(uint minToken0Out, uint minToken1Out, uint valueToBurn,address receiver) public nonReentrant {
            (uint112 reserve0, uint112 reserve1,) = getReserves();
            address _token0 = token0;
            address _token1 = token1;

            uint balance0 = IERC20(token0).balanceOf(address(this));
            uint balance1 = IERC20(token1).balanceOf(address(this));

            uint _totalSupply = totalSupply();
            uint amount0Out = valueToBurn * balance0 / _totalSupply;
            uint amount1Out = valueToBurn * balance1 / _totalSupply;
            require(amount0Out >= minToken0Out && amount1Out >=minToken1Out, 'INSUFFICIENT LIQUIDITY TO BURN');
            _safeTransfer(token0, receiver,amount0Out);
            _safeTransfer(token1, receiver, amount1Out);
            balance0 = IERC20(_token0).balanceOf(address(this));
            balance1 = IERC20(_token1).balanceOf(address(this));
      

            _update(balance0, balance1, reserve0, reserve1);
            kLast = Math.sqrt(reserve0 * reserve1);
            emit Burn(msg.sender, amount1Out, amount0Out, receiver);

        }


        function swapExactTokenForToken(address tokenIn, uint amountIn, uint minAmountOut, address to, bytes calldata data) external nonReentrant {
            (uint112 reserve0, uint112 reserve1,) = getReserves(); // gas savings
            require(tokenIn == token0 || tokenIn == token1, 'INVALID TOKEN');

            address tokenOut;
            uint112 reserveIn;
            uint112 reserveOut;
            // default token0 is tokenIn, token1 is tokenOut
            if(tokenIn == token1){
                
                tokenOut = token0;
                reserveOut = reserve0;
                reserveIn = reserve1;
            }else {
                tokenOut = token1;
                reserveOut = reserve1;
                reserveIn = reserve0;
            }

            
     
            uint numerator = (amountIn * 997) * reserveOut;
            uint denominator = reserveIn * 1000 + (amountIn * 997);
            uint amountOut = numerator / denominator;
            
            require(amountOut >= minAmountOut, 'INSUFFICIENT TOKEN AMOUNT TO SWAP');

            _safeTransferFrom(tokenIn, msg.sender, address(this), amountIn);
            _safeTransfer(tokenOut, to, amountOut);
            uint balance0 = IERC20(token0).balanceOf(address(this));
            uint balance1 = IERC20(token1).balanceOf(address(this));
            _update(balance0, balance1, reserve0, reserve1);
            if(tokenIn == token1){
                if (data.length > 0) IUniswapV2Callee(to).uniswapV2Call(msg.sender, amountOut, 0, data);
                emit Swap(msg.sender, 0, amountIn, amountOut, 0, to);
            }else {
                if (data.length > 0) IUniswapV2Callee(to).uniswapV2Call(msg.sender, 0, amountOut, data);
                emit Swap(msg.sender, amountIn, 0, 0, amountOut, to);
            }
            
            
        }

        function swapTokenForExactToken(address tokenIn, uint amountOut, uint maxAmountIn, address to, bytes calldata data) external nonReentrant{
            (uint112 reserve0, uint112 reserve1,) = getReserves(); // gas savings
            require(tokenIn == token0 || tokenIn == token1, 'INVALID TOKEN');

            address tokenOut;
            uint112 reserveIn;
            uint112 reserveOut;
            // default token0 is tokenIn, token1 is tokenOut
            if(tokenIn == token1){
                
                tokenOut = token0;
                reserveOut = reserve0;
                reserveIn = reserve1;
            }else {
                tokenOut = token1;
                reserveOut = reserve1;
                reserveIn = reserve0;
            }

            uint numerator = reserveIn * amountOut* 1000;
            uint denominator = (reserveOut - amountOut) * 997;
            uint amountIn = (numerator / denominator) + 1; // prevent round down error
            require(amountIn <= maxAmountIn, 'NOT ENOUGH TOKEN IN');

            _safeTransferFrom(tokenIn, msg.sender, address(this), amountIn);
            _safeTransfer(tokenOut, to, amountOut);
            uint balance0 = IERC20(token0).balanceOf(address(this));
            uint balance1 = IERC20(token1).balanceOf(address(this));
            _update(balance0, balance1, reserve0, reserve1);

            if(tokenIn == token1){
                if (data.length > 0) IUniswapV2Callee(to).uniswapV2Call(msg.sender, amountOut, 0, data);
                emit Swap(msg.sender, 0, amountIn, amountOut, 0, to);
            }else {
                if (data.length > 0) IUniswapV2Callee(to).uniswapV2Call(msg.sender, 0, amountOut, data);
                emit Swap(msg.sender, amountIn, 0, 0, amountOut, to);
            }
     

        }

    //Usual flash loan
  function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external nonReentrant{
          require(amount0Out > 0 || amount1Out > 0, 'UniswapV2: INSUFFICIENT_OUTPUT_AMOUNT');
        (uint112 _reserve0, uint112 _reserve1,) = getReserves(); // gas savings
        require(amount0Out < _reserve0 && amount1Out < _reserve1, 'UniswapV2: INSUFFICIENT_LIQUIDITY');

        uint balance0;
        uint balance1;
        { // scope for _token{0,1}, avoids stack too deep errors
        address _token0 = token0;
        address _token1 = token1;
        require(to != _token0 && to != _token1, 'UniswapV2: INVALID_TO');
        if (amount0Out > 0) _safeTransfer(_token0, to, amount0Out); // optimistically transfer tokens
        if (amount1Out > 0) _safeTransfer(_token1, to, amount1Out); // optimistically transfer tokens
        if (data.length > 0) IUniswapV2Callee(to).uniswapV2Call(msg.sender, amount0Out, amount1Out, data);
        balance0 = IERC20(_token0).balanceOf(address(this));
        balance1 = IERC20(_token1).balanceOf(address(this));
        }
        uint amount0In = balance0 > _reserve0 - amount0Out ? balance0 - (_reserve0 - amount0Out) : 0;
        uint amount1In = balance1 > _reserve1 - amount1Out ? balance1 - (_reserve1 - amount1Out) : 0;
        require(amount0In > 0 || amount1In > 0, 'UniswapV2: INSUFFICIENT_INPUT_AMOUNT');
        { // scope for reserve{0,1}Adjusted, avoids stack too deep errors
        uint balance0Adjusted = balance0*(1000)- (amount0In*(3));
        uint balance1Adjusted = balance1*(1000)- (amount1In*(3));
        require(balance0Adjusted * (balance1Adjusted) >= uint(_reserve0)* (_reserve1)*(1000**2), 'UniswapV2: K');
        }

        _update(balance0, balance1, _reserve0, _reserve1);
        emit Swap(msg.sender, amount0In, amount1In, amount0Out, amount1Out, to);

    }

         /**
     * @dev Loan `amount` tokens to `receiver`, and takes it back plus a `flashFee` after the callback.
     * @param receiver The contract receiving the tokens, needs to implement the `onFlashLoan(address user, uint256 amount, uint256 fee, bytes calldata)` interface.
     * @param token The loan currency.
     * @param amount The amount of tokens lent.
     * @param data A data parameter to be passed on to the `receiver` for any custom use.
     */
    function flashLoan(
        IERC3156FlashBorrower receiver,
        address token,
        uint256 amount,
        bytes calldata data
    ) external override returns(bool) {
        (uint112 _reserve0, uint112 _reserve1,) = getReserves(); // gas savings
        require(
            token == token0 || token == token1,
            "FlashLender: Unsupported currency"
        );
        uint256 fee = _flashFee(token, amount);
        require(amount<= _maxFlashLoan(token), 'FLASHLOAN EXCEED LIMIT');
        require(
            IERC20(token).transfer(address(receiver), amount),
            "FlashLender: Transfer failed"
        );
        require(
            receiver.onFlashLoan(msg.sender, token, amount, fee, data) == CALLBACK_SUCCESS,
            "FlashLender: Callback failed"
        );
        require(
            IERC20(token).transferFrom(address(receiver), address(this), amount + fee),
            "FlashLender: Repay failed"
        );
        uint balance0 = IERC20(token0).balanceOf(address(this));
        uint balance1 = IERC20(token1).balanceOf(address(this));
        _update(balance0, balance1, reserve0, reserve1);
        
        return true;
    }


    /**
     * @dev The fee to be charged for a given loan.
     * @param token The loan currency.
     * @param amount The amount of tokens lent.
     * @return The amount of `token` to be charged for the loan, on top of the returned principal.
     */
    function flashFee(
        address token,
        uint256 amount
    ) external view override returns (uint256) {
        require(
            token == token0 || token == token1,
            "FlashLender: Unsupported currency"
        );
        return _flashFee(token, amount);
    }

    /**
     * @dev The fee to be charged for a given loan. Internal function with no checks.
     * @param token The loan currency.
     * @param amount The amount of tokens lent.
     * @return The amount of `token` to be charged for the loan, on top of the returned principal.
     */
    function _flashFee(
        address token,
        uint256 amount
    ) internal view returns (uint256) {
        return amount * flashLoanFee / 10000;
    }

    /**
     * @dev The amount of currency available to be lent.
     * @param token The loan currency.
     * @return The amount of `token` that can be borrowed.
     */
    function maxFlashLoan(
        address token
    ) external view override returns (uint256) {
        uint256 maxAmount = _maxFlashLoan(token);
        return maxAmount;
    }

    function _maxFlashLoan(address token) internal view returns (uint256) {
        return (token == token0 || token == token1) ? IERC20(token).balanceOf(address(this)) : 0;
    }


        

    

}
