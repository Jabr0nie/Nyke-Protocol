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

    function GetUnderlyingPrice(address cToken) public view returns (uint) {
        address _poolAddress;
        uint price;
        if (cToken == 0x2896c67c0cea9D4954d6d8f695b6680fCfa7C0e0) {
            _poolAddress = 0xE7F43da4Dff1eF4321f6AA3485B825a57A97C772;
        }
        else if (cToken == 0xA11d739365d469c87F3daBd922a82cfF21b71c9B) {
            price = 1000000000000000000;
            return price;
        }
    
        (int56[] memory tickCumulatives,) = IETCswapV3PoolDerivedState(_poolAddress).observe(secondsAgos);
        int56 ticka = tickCumulatives[0];
        int56 tickb = tickCumulatives[1];
        int56 tick = (ticka-tickb)/180;
        int24 tick24 = int24(tick);
        uint160 sqrtRatioX96 = TickMath.getSqrtRatioAtTick(tick24);
        uint256 a = uint256(sqrtRatioX96);
        uint256 s = (a ** 2);
        uint256 t = (2 ** 192);
        uint256 r = (10 ** 14);
        uint256 d = FullMath.mulDiv(s,r,t);
        price = (d * r)*(10 ** 2);
        return price;
    }
}
