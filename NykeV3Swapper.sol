// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity >=0.7.6;
pragma abicoder v2;

import "./IETCswapV3PoolState.sol";
import "./TickMath.sol";
import "./FullMath.sol";
import "./TransferHelper.sol";

interface IUniswapV3PoolActions {
    /// @notice Swap token0 for token1, or token1 for token0
    /// @dev The caller of this method receives a callback in the form of IUniswapV3SwapCallback#uniswapV3SwapCallback
    /// @param recipient The address to receive the output of the swap
    /// @param zeroForOne The direction of the swap, true for token0 to token1, false for token1 to token0
    /// @param amountSpecified The amount of the swap, which implicitly configures the swap as exact input (positive), or exact output (negative)
    /// @param sqrtPriceLimitX96 The Q64.96 sqrt price limit. If zero for one, the price cannot be less than this
    /// value after the swap. If one for zero, the price cannot be greater than this value after the swap
    /// @param data Any data to be passed through to the callback
    /// @return amount0 The delta of the balance of token0 of the pool, exact when negative, minimum when positive
    /// @return amount1 The delta of the balance of token1 of the pool, exact when negative, minimum when positive
    function swap(
        address recipient,
        bool zeroForOne,
        int256 amountSpecified,
        uint160 sqrtPriceLimitX96,
        bytes calldata data
    ) external returns (int256 amount0, int256 amount1);
}

interface IWETC {
    function approve(address guy, uint256 wad) external returns (bool);
}

/// @title Callback for IETCswapV3PoolActions#swap
/// @notice Any contract that calls IETCswapV3PoolActions#swap must implement this interface
interface IETCswapV3SwapCallback {
    /// @notice Called to `msg.sender` after executing a swap via IETCswapV3Pool#swap.
    /// @dev In the implementation you must pay the pool tokens owed for the swap.
    /// The caller of this method must be checked to be a ETCswapV3Pool deployed by the canonical ETCswapV3Factory.
    /// amount0Delta and amount1Delta can both be 0 if no tokens were swapped.
    /// @param amount0Delta The amount of token0 that was sent (negative) or must be received (positive) by the pool by
    /// the end of the swap. If positive, the callback must send that amount of token0 to the pool.
    /// @param amount1Delta The amount of token1 that was sent (negative) or must be received (positive) by the pool by
    /// the end of the swap. If positive, the callback must send that amount of token1 to the pool.
    /// @param data Any data passed through by the caller via the IETCswapV3PoolActions#swap call
    function uniswapV3SwapCallback(
        int256 amount0Delta,
        int256 amount1Delta,
        bytes calldata data
    ) external;
}


contract SwapExamples {

        address immutable WETC = 0x1953cab0E5bFa6D4a9BaD6E05fD46C1CC6527a5a; //Token 0 - WETC
        address immutable NYKE = 0x9aa2901007fCE996e35305FD9bA196e17fCd2605; //Token 1 - USC 
        uint24 FEE_TIER = 3000; // 0.3% fee tier

            address public immutable pool;
            address public immutable token0;
            address public immutable token1;
    
    constructor(address _pool, address _token0, address _token1) {
        pool = _pool;
        token0 = _token0;
        token1 = _token1;
    }


    function swapExactInputSingle(int256 amountSpecified)
        external
        returns (uint256 amountOut)
    {
        // Define the token addresses and fee tiers
    //    address WETC = 0x1953cab0E5bFa6D4a9BaD6E05fD46C1CC6527a5a; //Token 0 - WETC
    //    address USC = 0x9aa2901007fCE996e35305FD9bA196e17fCd2605; //Token 1 - USC 
    //    uint24 FEE_TIER = 3000; // 0.3% fee tier


        bool zeroForOne = true;
        uint160 sqrtPriceLimitX96 = zeroForOne ? TickMath.MIN_SQRT_RATIO+1 : TickMath.MAX_SQRT_RATIO-1;

        IUniswapV3PoolActions(0x8fA4d94Ec93a839923ceb37194323d081a24f4Ec).swap(
            address(this), // recipient of the swap output
            zeroForOne,
            amountSpecified,
            sqrtPriceLimitX96,
            abi.encode(pool) // pass the pool address as data for validation in the callback
        );
    }

    function approveWETC(uint256 amountApprove) external payable {
        IWETC(0x1953cab0E5bFa6D4a9BaD6E05fD46C1CC6527a5a).approve(
            0x8fA4d94Ec93a839923ceb37194323d081a24f4Ec,
            amountApprove
        );
    }

        // Callback function to handle the swap logic
    function uniswapV3SwapCallback(
        int256 amount0Delta,
        int256 amount1Delta,
        bytes calldata data
    ) external {
        // Ensure the callback is from a valid Uniswap V3 pool
        address pool = abi.decode(data, (address));
        require(msg.sender == pool, "Invalid callback");

        // Handle the swap logic here
        // For example, transfer the required tokens to the pool
        if (amount0Delta > 0) {
            TransferHelper.safeTransfer(address(token0), msg.sender, uint256(amount0Delta));
        } else {
            TransferHelper.safeTransfer(address(token1), msg.sender, uint256(amount1Delta));
        }
    }
}
