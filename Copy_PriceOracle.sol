//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;


import "./IETCswapV3PoolState.sol";
import "./CErc20.sol";
import "./CToken.sol";



contract PriceOracle {
    IETCswapV3PoolState public ETCswapV3Pool;
     mapping(address => uint) prices;
     address public admin;

    event PricePosted(address _asset, uint previousPriceMantissa, uint requestedPriceMantissa, uint newPriceMantissa);

        constructor() {
        admin = msg.sender; // Setting the deployer as the initial admin
    }

    function _getUnderlyingAddress(CToken cToken) public view returns (address) {
                address _asset;
        if (compareStrings(cToken.symbol(), "nETC")) {
            _asset = 0x2896c67c0cea9D4954d6d8f695b6680fCfa7C0e0;
        } else {
            _asset = address(CErc20(address(cToken)).underlying());
        }
        return _asset;
    }

        function getUnderlyingPrice(CToken cToken) public view returns (uint) {
        return prices[_getUnderlyingAddress(cToken)];
    }

    function setUnderlyingPrice(CToken cToken, uint256 underlyingPriceMantissa) external {
        require(msg.sender == admin, "Only admin can set prices");
        address _asset = _getUnderlyingAddress(cToken);
        require(underlyingPriceMantissa > 0, "Price must be greater than zero");
        emit PricePosted(_asset, prices[_asset], underlyingPriceMantissa, underlyingPriceMantissa);
        prices[_asset] = underlyingPriceMantissa;
    }


    function setDirectPrice(address _poolAddress, address _asset) public {
        (uint160 sqrtPriceX96,, , , , , ) = IETCswapV3PoolState(_poolAddress).slot0();
        uint256 a = uint256(sqrtPriceX96);
        uint256 t = (2 ** 192);
        uint256 r = (10 ** 14);
        uint256 q = ((a ** 2) * r)/(t);
        uint256 price = q * (10 ** 16);
        emit PricePosted(_asset, prices[_asset], price, price);
    }


    function compareStrings(string memory a, string memory b) internal pure returns (bool) {
        return (keccak256(abi.encodePacked((a))) == keccak256(abi.encodePacked((b))));
    }
}
