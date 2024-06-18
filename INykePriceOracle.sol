pragma solidity >=0.5.0;

import "./IETCswapV3PoolState.sol";

contract PoolInteractor {
    IETCswapV3PoolState public ETCswapV3Pool;

    constructor (address _poolAddress) public{
        ETCswapV3Pool = IETCswapV3PoolState(_poolAddress);
    }

    function getCurrentTick() external view returns (int24) {
    (, int24 tick, , , , , ) = ETCswapV3Pool.slot0();
    return tick;
}
}
