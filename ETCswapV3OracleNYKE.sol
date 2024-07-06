// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity >=0.5.0;

import "./IETCswapV3PoolState.sol";
import "./TickMath.sol";
import "./FullMath.sol";

interface IETCswapV3PoolDerivedState {

    function observe(uint32[] calldata secondsAgos)
        external
        view
        returns (int56[] memory tickCumulatives, uint160[] memory secondsPerLiquidityCumulativeX128s);

}

contract ETCswapV3Oracle {

IETCswapV3PoolDerivedState public ETCswapV3Pool;

uint32[] private secondsAgos = [0,180];

    function GetUnderlyingPrice() public view returns (uint) {
        address _poolAddress = 0xA64CB403a44a5270EE0B82bCa09A302B3Bc2bc57;
        uint price;

    
        (int56[] memory tickCumulatives,) = IETCswapV3PoolDerivedState(_poolAddress).observe(secondsAgos);
        int56 ticka = tickCumulatives[0];
        int56 tickb = tickCumulatives[1];
        int56 tick = (ticka-tickb)/180;
        int24 tick24 = int24(tick);
        uint160 sqrtRatioX96 = TickMath.getSqrtRatioAtTick(tick24);
        uint256 a = uint256(sqrtRatioX96);
        uint256 s = (a ** 2);
        uint256 t = (2 ** 192);
        uint256 r = (10 ** 23);
        uint256 d = FullMath.mulDiv(s,r,t);
        price = (d)*(10 ** 7);
        return price;
    }
}
