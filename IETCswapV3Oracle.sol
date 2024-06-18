// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity >=0.5.0;


interface IETCswapV3Oracle {

    function GetUnderlyingPrice(address cToken) external view returns (uint);

}

