// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity >=0.5.0;


interface IHebeSwapRouter {
    function factory() external pure returns (address);
    function WETC() external pure returns (address);
    
    function swapExactTokensForTokens(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline) external returns (uint[] memory amounts);
    function swapTokensForExactTokens(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline) external returns (uint[] memory amounts);
    function swapExactETCForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline) external payable returns (uint[] memory amounts);
    function swapTokensForExactETC(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline) external returns (uint[] memory amounts);
    function swapExactTokensForETC(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline) external returns (uint[] memory amounts);
    function swapETCForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline) external payable
        returns (uint[] memory amounts);
    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
    function swapExactETCForTokensSupportingFeeOnTransferTokens(
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external payable;
    function swapExactTokensForETCSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
}

interface IETCswapV3PoolDerivedState {

    function observe(uint32[] calldata secondsAgos)
        external
        view
        returns (int56[] memory tickCumulatives, uint160[] memory secondsPerLiquidityCumulativeX128s);

}

interface CTokenInterfaces {
    function _setPendingAdmin(address payable newPendingAdmin) external returns (uint);
    function _acceptAdmin() external returns (uint);
    function _setComptroller(address newComptroller) external returns (uint);
    function _setReserveFactor(uint newReserveFactorMantissa) external returns (uint);
    function _reduceReserves(uint reduceAmount) external returns (uint);
    function _setInterestRateModel(address newInterestRateModel) external returns (uint);   
}

interface ICToken {
    function totalReserves() external view returns (uint);
}

contract DistributeRevenue {
address admin;

    constructor() {
        admin = msg.sender;
    }

address nETC = 0x2896c67c0cea9D4954d6d8f695b6680fCfa7C0e0;
address TestRevenuePayout = 0x0B9BC785fd2Bea7bf9CB81065cfAbA2fC5d0286B;
uint32[] public secondsAgos = [0,180];


    function GetUnderlyingPrice(address _poolAddress) public view returns (int56[] memory) {
       (int56[] memory tickCumulatives,) = IETCswapV3PoolDerivedState(_poolAddress).observe(secondsAgos);
    return (tickCumulatives);  
    }


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
        (uint ETCReserves) = ICToken(nETC).totalReserves();
        CTokenInterfaces(nETC)._reduceReserves(ETCReserves);

    }

    function swapETCForToken() external payable {
        address[] memory path = new address[](2);
        path[0] = IHebeSwapRouter(0xEcBcF5C7aF4c323947CFE982940BA7c9fd207e2b).WETC();
        path[1] = 0x14Aab1756A7d441d70583e6a67efE2D696423996; //test token

        uint tokenAmountOutMin = 0;
        uint amountIn = 10000000000000000;
        
        IHebeSwapRouter(0xEcBcF5C7aF4c323947CFE982940BA7c9fd207e2b).swapExactETCForTokensSupportingFeeOnTransferTokens{ 
            value: amountIn
        }(
            tokenAmountOutMin,
            path,
            address(this), // or address(this) if you want to keep the tokens in the contract
            block.timestamp + 300 // deadline in 5 minutes
        );
    }

        function sendETC(address payable recipient, uint256 amount) public {
        require(address(this).balance >= amount, "Insufficient balance in contract");
        (bool sent, ) = recipient.call{value: amount}("");
        require(sent, "Failed to send ETC");
    }

    // Function to receive ETC
    receive() external payable {}

}