// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity >=0.5.0;

import './IETCswapV3PoolImmutables.sol';
import './IETCswapV3PoolState.sol';
import './IETCswapV3PoolDerivedState.sol';
import './IETCswapV3PoolActions.sol';
import './IETCswapV3PoolOwnerActions.sol';
import './IETCswapV3PoolEvents.sol';

/// @title The interface for a ETCswap V3 Pool
/// @notice A ETCswap pool facilitates swapping and automated market making between any two assets that strictly conform
/// to the ERC20 specification
/// @dev The pool interface is broken up into many smaller pieces
interface IETCswapV3Pool is
    IETCswapV3PoolImmutables,
    IETCswapV3PoolState,
    IETCswapV3PoolDerivedState,
    IETCswapV3PoolActions,
    IETCswapV3PoolOwnerActions,
    IETCswapV3PoolEvents
{

}
