//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;


import "./IETCswapV3PoolState.sol";


interface IETCswapV3PoolDerivedState {
        function observe(uint32[] calldata secondsAgo)
        external
        view
        returns (int56[] memory tickCumulatives, uint160[] memory secondsPerLiquidityCumulativeX128s);
}

contract PriceOracle {

    /// @notice Indicator that this is a PriceOracle contract (for inspection)
    bool public constant isPriceOracle = true;
    IETCswapV3PoolState public ETCswapV3Pool;
    IETCswapV3PoolDerivedState public ETCswapV3PoolObserve;
     mapping(address => uint) prices;
     address public admin;


    event PricePosted(address _asset, uint previousPriceMantissa, uint requestedPriceMantissa, uint newPriceMantissa);

        constructor() {
        admin = msg.sender; // Setting the deployer as the initial admin
    }

    function UpdateUnderlyingPrice(address cToken) public {
        address _poolAddress;
        address asset;
        if (cToken == 0x2896c67c0cea9D4954d6d8f695b6680fCfa7C0e0) {
            _poolAddress = 0xE7F43da4Dff1eF4321f6AA3485B825a57A97C772;
        } 
        (uint160 sqrtPriceX96,, , , , , ) = IETCswapV3PoolState(_poolAddress).slot0();
        uint a = uint(sqrtPriceX96);
        uint t = (2 ** 192);
        uint r = (10 ** 14);
        uint q = ((a ** 2) * r)/(t);
        uint price = q * (10 ** 16);
        asset = cToken;
        emit PricePosted(asset, prices[asset], price, price);
        prices[asset] = price;
    }

    function getUnderlyingPrice(address asset) public view returns (uint) {
        return prices[asset];
    }


    function TWAP(address cToken,uint32[] calldata secondsAgo) external view {
        address _poolAddress;
        if (cToken == 0x2896c67c0cea9D4954d6d8f695b6680fCfa7C0e0) {
            _poolAddress = 0xE7F43da4Dff1eF4321f6AA3485B825a57A97C772;
        } 
      IETCswapV3PoolDerivedState(_poolAddress).observe(secondsAgo);
    }



}
