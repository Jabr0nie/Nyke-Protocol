// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity >=0.7.6;
pragma abicoder v2;

import "./IETCswapV3PoolState.sol";
import "./TickMath.sol";
import "./FullMath.sol";
import "./TransferHelper.sol";

interface IERC20Upgradeable {
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address to, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address from, address to, uint256 amount) external returns (bool);
}


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
        function deposit() external payable;


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




interface IETCswapV3PoolDerivedState {

    function observe(uint32[] calldata secondsAgos)
        external
        view
        returns (int56[] memory tickCumulatives, uint160[] memory secondsPerLiquidityCumulativeX128s);

}

interface NYKE {
    function balanceOf(address account) external view returns (uint);

    function transfer(address dst, uint rawAmount) external returns (bool);
}

interface CTokenInterfaces {

    /*** Admin Functions ***/

    function _setPendingAdmin(address payable newPendingAdmin) external returns (uint);
    function _acceptAdmin() external returns (uint);
    function _setComptroller(address newComptroller) external returns (uint);
    function _setReserveFactor(uint newReserveFactorMantissa) external returns (uint);
    function _reduceReserves(uint reduceAmount) external returns (uint);
    function _setInterestRateModel(address newInterestRateModel) external returns (uint);
    function _addReserves(uint addAmount) external returns (uint);


    function transfer(address dst, uint amount) external returns (bool);
    function transferFrom(address src, address dst, uint amount) external returns (bool);
    function approve(address spender, uint amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint);
    function balanceOf(address owner) external view returns (uint);
}


interface ICToken {
    function totalReserves() external view returns (uint);
}

contract DistributorV3 {

//address immutable WETC = 0x1953cab0E5bFa6D4a9BaD6E05fD46C1CC6527a5a; //Token 0 - WETC
//address immutable NYKE = 0x9aa2901007fCE996e35305FD9bA196e17fCd2605; //Token 1 - NYKE 
//uint24 FEE_TIER = 3000; // 0.3% fee tier

address public immutable pool;
address public immutable token0;
address public immutable token1;
address admin;

    constructor(address _pool, address _token0, address _token1) {
        admin = msg.sender;
        pool = _pool;
        token0 = _token0;
        token1 = _token1;
    }

address nUSC = 0xA11d739365d469c87F3daBd922a82cfF21b71c9B;

    function SetDistributorAdmin(address newDistributorAdmin) public {
         require(msg.sender == admin);
         admin = newDistributorAdmin;
    }

    function updateCTokenAdmin(address cToken, address payable newCTokenAdmin) public {
        require(msg.sender == admin);
        CTokenInterfaces(cToken)._setPendingAdmin(newCTokenAdmin);
    }

    function acceptCTokenAdmin(address cToken) public {
        require(msg.sender == admin);
        CTokenInterfaces(cToken)._acceptAdmin();
    }


    function collectRevenue() external payable{
        //Collect Revenue
        (uint USCReserves) = ICToken(nUSC).totalReserves();
        CTokenInterfaces(nUSC)._reduceReserves(USCReserves);

        //Swap
        int256 amountSpecified = int256(USCReserves);
        bool zeroForOne = false;
        uint160 sqrtPriceLimitX96 = zeroForOne ? TickMath.MIN_SQRT_RATIO+1 : TickMath.MAX_SQRT_RATIO-1;

        IUniswapV3PoolActions(0xA64CB403a44a5270EE0B82bCa09A302B3Bc2bc57).swap(
            address(this), // recipient of the swap output
            zeroForOne,
            amountSpecified,
            sqrtPriceLimitX96,
            abi.encode(pool) // pass the pool address as data for validation in the callback
        );

        //Burn NYKE
        (uint NYKEBalance) = NYKE(0x9aa2901007fCE996e35305FD9bA196e17fCd2605).balanceOf(address(this));
        NYKE(0x9aa2901007fCE996e35305FD9bA196e17fCd2605).transfer(0x000000000000000000000000000000000000dEaD,NYKEBalance);
        }
    

    function burnNYKE (uint BurnAmount)  external payable{
        NYKE(0x9aa2901007fCE996e35305FD9bA196e17fCd2605).transfer(0x000000000000000000000000000000000000dEaD,BurnAmount);
    }

    function addreserves(uint addAmount) external payable{
        require(msg.sender == admin);
        CTokenInterfaces(nUSC)._addReserves(addAmount);
    }


    function setCTokenComptroller(address NewComptroller) external payable{
         require(msg.sender == admin);
        CTokenInterfaces(nUSC)._setComptroller(NewComptroller);
    }

    function setCTokenReserveFactor(uint newReserveFactorMantissa) external payable{
        require(msg.sender == admin);
    CTokenInterfaces(nUSC)._setReserveFactor(newReserveFactorMantissa);
    }

    function setCTokenInterestRateModel(address NewInterestRateModel) external payable{
        require(msg.sender == admin);
        CTokenInterfaces(nUSC)._setInterestRateModel(NewInterestRateModel);
    }

    function transferUSC(uint256 amountApprove) external payable {
        IERC20Upgradeable(0xDE093684c796204224BC081f937aa059D903c52a).transfer(0x0B9BC785fd2Bea7bf9CB81065cfAbA2fC5d0286B, amountApprove);
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

        function _approveUSC(uint256 amountApprove) external payable {
            IERC20Upgradeable(0xDE093684c796204224BC081f937aa059D903c52a).approve(0xA64CB403a44a5270EE0B82bCa09A302B3Bc2bc57, amountApprove);        }



    // Function to receive ETC
    receive() external payable {}
}