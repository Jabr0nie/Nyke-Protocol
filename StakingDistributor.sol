pragma solidity ^0.8.0;

contract ReserveDistributor {
    mapping(address => uint256) public compStaked;
    uint256 public totalCompStaked;
    address public reserveAsset;  // Address of the reserve asset, e.g., USDC
    uint256 public totalReservesAvailable;

    constructor(address _reserveAsset) {
        reserveAsset = _reserveAsset;
    }

    function distributeReserves() external {
        require(totalReservesAvailable > 0, "No reserves to distribute");
        require(totalCompStaked > 0, "No COMP staked");

        uint256 reservesPerComp = totalReservesAvailable / totalCompStaked;

        for (uint i = 0; i < stakers.length; i++) {
            address staker = stakers[i];
            uint256 stakerShare = compStaked[staker] * reservesPerComp;
            ERC20(reserveAsset).transfer(staker, stakerShare);
        }

        // Reset reserves after distribution
        totalReservesAvailable = 0;
    }

    function stakeNyke(uint256 amount, address staker) external {
        compStaked[staker] += amount;
        totalCompStaked += amount;
    }

    function addReserves(uint256 amount) external {
        totalReservesAvailable += amount;
    }
}