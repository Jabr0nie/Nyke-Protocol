pragma solidity 0.7.6;
pragma abicoder v2;


interface IERC20 {
    
    function totalSupply() external view returns (uint256);

    
    function balanceOf(address account) external view returns (uint256);

    
    function transfer(address recipient, uint256 amount) external returns (bool);

    
    function allowance(address owner, address spender) external view returns (uint256);

    
    function approve(address spender, uint256 amount) external returns (bool);

    
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    
    event Transfer(address indexed from, address indexed to, uint256 value);

    
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

library SafeMath {
    
    function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        uint256 c = a + b;
        if (c < a) return (false, 0);
        return (true, c);
    }

    
    function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        if (b > a) return (false, 0);
        return (true, a - b);
    }

    
    function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        
        
        
        if (a == 0) return (true, 0);
        uint256 c = a * b;
        if (c / a != b) return (false, 0);
        return (true, c);
    }

    
    function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        if (b == 0) return (false, 0);
        return (true, a / b);
    }

    
    function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        if (b == 0) return (false, 0);
        return (true, a % b);
    }

    
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");
        return c;
    }

    
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a, "SafeMath: subtraction overflow");
        return a - b;
    }

    
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) return 0;
        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");
        return c;
    }

    
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b > 0, "SafeMath: division by zero");
        return a / b;
    }

    
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b > 0, "SafeMath: modulo by zero");
        return a % b;
    }

    
    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        return a - b;
    }

    
    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        return a / b;
    }

    
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        return a % b;
    }
}

library Address {
    
    function isContract(address account) internal view returns (bool) {
        
        
        

        uint256 size;
        
        assembly { size := extcodesize(account) }
        return size > 0;
    }

    
    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");

        
        (bool success, ) = recipient.call{ value: amount }("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }

    
    function functionCall(address target, bytes memory data) internal returns (bytes memory) {
      return functionCall(target, data, "Address: low-level call failed");
    }

    
    function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
        return functionCallWithValue(target, data, 0, errorMessage);
    }

    
    function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
    }

    
    function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
        require(address(this).balance >= value, "Address: insufficient balance for call");
        require(isContract(target), "Address: call to non-contract");

        
        (bool success, bytes memory returndata) = target.call{ value: value }(data);
        return _verifyCallResult(success, returndata, errorMessage);
    }

    
    function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
        return functionStaticCall(target, data, "Address: low-level static call failed");
    }

    
    function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
        require(isContract(target), "Address: static call to non-contract");

        
        (bool success, bytes memory returndata) = target.staticcall(data);
        return _verifyCallResult(success, returndata, errorMessage);
    }

    
    function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionDelegateCall(target, data, "Address: low-level delegate call failed");
    }

    
    function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
        require(isContract(target), "Address: delegate call to non-contract");

        
        (bool success, bytes memory returndata) = target.delegatecall(data);
        return _verifyCallResult(success, returndata, errorMessage);
    }

    function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
        if (success) {
            return returndata;
        } else {
            
            if (returndata.length > 0) {
                

                
                assembly {
                    let returndata_size := mload(returndata)
                    revert(add(32, returndata), returndata_size)
                }
            } else {
                revert(errorMessage);
            }
        }
    }
}

library SafeERC20 {
    using SafeMath for uint256;
    using Address for address;

    function safeTransfer(IERC20 token, address to, uint256 value) internal {
        _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
    }

    function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
        _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
    }

    
    function safeApprove(IERC20 token, address spender, uint256 value) internal {
        
        
        
        
        require((value == 0) || (token.allowance(address(this), spender) == 0),
            "SafeERC20: approve from non-zero to non-zero allowance"
        );
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
    }

    function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
        uint256 newAllowance = token.allowance(address(this), spender).add(value);
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
    }

    function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
        uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
    }

    
    function _callOptionalReturn(IERC20 token, bytes memory data) private {
        
        
        

        bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
        if (returndata.length > 0) { 
            
            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
        }
    }
}

abstract contract Context {
    function _msgSender() internal view virtual returns (address payable) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes memory) {
        this; 
        return msg.data;
    }
}

abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    
    constructor () {
        address msgSender = _msgSender();
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }

    
    function owner() public view virtual returns (address) {
        return _owner;
    }

    
    modifier onlyOwner() {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    
    function renounceOwnership() public virtual onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

interface IChefIncentivesController {
  
  function handleAction(
    address user,
    uint256 userBalance,
    uint256 totalSupply
  ) external;

  function addPool(address _token, uint256 _allocPoint) external;

  function claim(address _user, address[] calldata _tokens) external;

  function setClaimReceiver(address _user, address _receiver) external;
}

interface IMultiFeeDistribution {
  function addReward(address rewardsToken) external;

  function mint(
    address user,
    uint256 amount,
    bool withPenalty
  ) external;
}

interface IMintableToken is IERC20 {
  function mint(address _receiver, uint256 _amount) external returns (bool);

  function setMinter(address _minter) external returns (bool);
}

contract MultiFeeDistribution is IMultiFeeDistribution, Ownable {
  using SafeMath for uint256;
  using SafeERC20 for IERC20;
  using SafeERC20 for IMintableToken;

  

  struct Reward {
    uint256 periodFinish;
    uint256 rewardRate;
    uint256 lastUpdateTime;
    uint256 rewardPerTokenStored;
    
    
    uint256 balance;
  }
  struct Balances {
    uint256 total;
    uint256 unlocked;
    uint256 locked;
    uint256 earned;
  }
  struct LockedBalance {
    uint256 amount;
    uint256 unlockTime;
  }
  struct RewardData {
    address token;
    uint256 amount;
  }

  IChefIncentivesController public incentivesController;
  IMintableToken public immutable stakingToken;
  address[] public rewardTokens;
  mapping(address => Reward) public rewardData;

  
  uint256 public constant rewardsDuration = 86400 * 7;

  
  uint256 public constant lockDuration = rewardsDuration * 13;

  
  mapping(address => bool) public minters;
  bool public mintersAreSet;

  
  mapping(address => mapping(address => uint256)) public userRewardPerTokenPaid;
  mapping(address => mapping(address => uint256)) public rewards;

  uint256 public totalSupply;
  uint256 public lockedSupply;

  
  mapping(address => Balances) private balances;
  mapping(address => LockedBalance[]) private userLocks;
  mapping(address => LockedBalance[]) private userEarnings;

  
  uint256 public vestingLockTimestamp;

  

  constructor(address _stakingToken, uint256 _vestingLockTimestamp) Ownable() {
    require((_vestingLockTimestamp - block.timestamp) < lockDuration, "Vesting lock time cannot exceed normal lock duration");
    stakingToken = IMintableToken(_stakingToken);
    IMintableToken(_stakingToken).setMinter(address(this));
    
    
    rewardTokens.push(_stakingToken);
    rewardData[_stakingToken].lastUpdateTime = block.timestamp;
    vestingLockTimestamp = _vestingLockTimestamp;
  }

  

  function setMinters(address[] memory _minters) external onlyOwner {
    require(!mintersAreSet);
    for (uint256 i; i < _minters.length; i++) {
      minters[_minters[i]] = true;
    }
    mintersAreSet = true;
  }

  function setIncentivesController(IChefIncentivesController _controller) external onlyOwner {
    incentivesController = _controller;
  }

  
  function addReward(address _rewardsToken) external override onlyOwner {
    require(rewardData[_rewardsToken].lastUpdateTime == 0);
    rewardTokens.push(_rewardsToken);
    rewardData[_rewardsToken].lastUpdateTime = block.timestamp;
    rewardData[_rewardsToken].periodFinish = block.timestamp;
  }

  

  function _rewardPerToken(address _rewardsToken, uint256 _supply) internal view returns (uint256) {
    if (_supply == 0) {
      return rewardData[_rewardsToken].rewardPerTokenStored;
    }
    return
      rewardData[_rewardsToken].rewardPerTokenStored.add(
        lastTimeRewardApplicable(_rewardsToken)
          .sub(rewardData[_rewardsToken].lastUpdateTime)
          .mul(rewardData[_rewardsToken].rewardRate)
          .mul(1e18)
          .div(_supply)
      );
  }

  function _earned(
    address _user,
    address _rewardsToken,
    uint256 _balance,
    uint256 _currentRewardPerToken
  ) internal view returns (uint256) {
    return
      _balance.mul(_currentRewardPerToken.sub(userRewardPerTokenPaid[_user][_rewardsToken])).div(1e18).add(
        rewards[_user][_rewardsToken]
      );
  }

  function lastTimeRewardApplicable(address _rewardsToken) public view returns (uint256) {
    uint256 periodFinish = rewardData[_rewardsToken].periodFinish;
    return block.timestamp < periodFinish ? block.timestamp : periodFinish;
  }

  function rewardPerToken(address _rewardsToken) external view returns (uint256) {
    uint256 supply = _rewardsToken == address(stakingToken) ? lockedSupply : totalSupply;
    return _rewardPerToken(_rewardsToken, supply);
  }

  function getRewardForDuration(address _rewardsToken) external view returns (uint256) {
    return rewardData[_rewardsToken].rewardRate.mul(rewardsDuration).div(1e12);
  }

  
  function claimableRewards(address account) external view returns (RewardData[] memory rewards) {
    rewards = new RewardData[](rewardTokens.length);
    for (uint256 i = 0; i < rewards.length; i++) {
      
      uint256 balance = i == 0 ? balances[account].locked : balances[account].total;
      uint256 supply = i == 0 ? lockedSupply : totalSupply;
      rewards[i].token = rewardTokens[i];
      rewards[i].amount = _earned(account, rewards[i].token, balance, _rewardPerToken(rewardTokens[i], supply)).div(
        1e12
      );
    }
    return rewards;
  }

  
  function totalBalance(address user) external view returns (uint256 amount) {
    return balances[user].total;
  }

  
  function unlockedBalance(address user) external view returns (uint256 amount) {
    amount = balances[user].unlocked;
    LockedBalance[] storage earnings = userEarnings[msg.sender];
    for (uint256 i = 0; i < earnings.length; i++) {
      if (earnings[i].unlockTime > block.timestamp) {
        break;
      }
      amount = amount.add(earnings[i].amount);
    }
    return amount;
  }

  
  
  function earnedBalances(address user) external view returns (uint256 total, LockedBalance[] memory earningsData) {
    LockedBalance[] storage earnings = userEarnings[user];
    uint256 idx;
    for (uint256 i = 0; i < earnings.length; i++) {
      if (earnings[i].unlockTime > block.timestamp) {
        if (idx == 0) {
          earningsData = new LockedBalance[](earnings.length - i);
        }
        earningsData[idx] = earnings[i];
        idx++;
        total = total.add(earnings[i].amount);
      }
    }
    return (total, earningsData);
  }

  
  function lockedBalances(address user)
    external
    view
    returns (
      uint256 total,
      uint256 unlockable,
      uint256 locked,
      LockedBalance[] memory lockData
    )
  {
    LockedBalance[] storage locks = userLocks[user];
    uint256 idx;
    for (uint256 i = 0; i < locks.length; i++) {
      if (locks[i].unlockTime > block.timestamp) {
        if (idx == 0) {
          lockData = new LockedBalance[](locks.length - i);
        }
        lockData[idx] = locks[i];
        idx++;
        locked = locked.add(locks[i].amount);
      } else {
        unlockable = unlockable.add(locks[i].amount);
      }
    }
    return (balances[user].locked, unlockable, locked, lockData);
  }

  
  function withdrawableBalance(address user) public view returns (uint256 amount, uint256 penaltyAmount) {
    Balances storage bal = balances[user];
    uint256 earned = bal.earned;
    if (earned > 0) {
      uint256 amountWithoutPenalty;
      uint256 length = userEarnings[user].length;
      for (uint256 i = 0; i < length; i++) {
        uint256 earnedAmount = userEarnings[user][i].amount;
        if (earnedAmount == 0) continue;
        if (userEarnings[user][i].unlockTime > block.timestamp) {
          break;
        }
        amountWithoutPenalty = amountWithoutPenalty.add(earnedAmount);
      }

      penaltyAmount = earned.sub(amountWithoutPenalty).div(2);
    }
    amount = bal.unlocked.add(earned).sub(penaltyAmount);
    return (amount, penaltyAmount);
  }

  

  
  
  function stake(uint256 amount, bool lock) external {
    require(amount > 0, "Cannot stake 0");
    _updateReward(msg.sender);
    totalSupply = totalSupply.add(amount);
    Balances storage bal = balances[msg.sender];
    bal.total = bal.total.add(amount);
    if (lock) {
      lockedSupply = lockedSupply.add(amount);
      bal.locked = bal.locked.add(amount);
      uint256 unlockTime = block.timestamp.div(rewardsDuration).mul(rewardsDuration).add(lockDuration);
      uint256 idx = userLocks[msg.sender].length;
      if (idx == 0 || userLocks[msg.sender][idx - 1].unlockTime < unlockTime) {
        userLocks[msg.sender].push(LockedBalance({ amount: amount, unlockTime: unlockTime }));
      } else {
        userLocks[msg.sender][idx - 1].amount = userLocks[msg.sender][idx - 1].amount.add(amount);
      }
    } else {
      bal.unlocked = bal.unlocked.add(amount);
    }
    stakingToken.safeTransferFrom(msg.sender, address(this), amount);
    emit Staked(msg.sender, amount, lock);
  }

  
  
  
  function mint(
    address user,
    uint256 amount,
    bool withPenalty
  ) external override {
    require(minters[msg.sender]);
    if (amount == 0) return;
    _updateReward(user);
    stakingToken.mint(address(this), amount);
    if (user == address(this)) {
      
      _notifyReward(address(stakingToken), amount);
      return;
    }
    totalSupply = totalSupply.add(amount);
    Balances storage bal = balances[user];
    bal.total = bal.total.add(amount);
    if (withPenalty) {
      bal.earned = bal.earned.add(amount);
      uint256 unlockTime = block.timestamp.div(rewardsDuration).mul(rewardsDuration).add(lockDuration);
      LockedBalance[] storage earnings = userEarnings[user];
      uint256 idx = earnings.length;
      if (idx == 0 || earnings[idx - 1].unlockTime < unlockTime) {
        earnings.push(LockedBalance({ amount: amount, unlockTime: unlockTime }));
      } else {
        earnings[idx - 1].amount = earnings[idx - 1].amount.add(amount);
      }
    } else {
      bal.unlocked = bal.unlocked.add(amount);
    }
    emit Staked(user, amount, false);
  }

  
  
  
  function withdraw(uint256 amount) public {
    require(amount > 0, "Cannot withdraw 0");
    _updateReward(msg.sender);
    Balances storage bal = balances[msg.sender];
    uint256 penaltyAmount;

    if (amount <= bal.unlocked) {
      bal.unlocked = bal.unlocked.sub(amount);
    } else {
      require(block.timestamp > vestingLockTimestamp, "Vested tokens must be claimed after the required lock timestamp");
      uint256 remaining = amount.sub(bal.unlocked);
      require(bal.earned >= remaining, "Insufficient unlocked balance");
      bal.unlocked = 0;
      bal.earned = bal.earned.sub(remaining);
      for (uint256 i = 0; ; i++) {
        uint256 earnedAmount = userEarnings[msg.sender][i].amount;
        if (earnedAmount == 0) continue;
        if (penaltyAmount == 0 && userEarnings[msg.sender][i].unlockTime > block.timestamp) {
          penaltyAmount = remaining;
          require(bal.earned >= remaining || remaining == bal.earned.add(1), "Insufficient balance after penalty");
          if (remaining == bal.earned.add(1)) {
            
            penaltyAmount = remaining.sub(1);
            bal.earned = 0;
          }else{
            bal.earned = bal.earned.sub(remaining);
          }
          if (bal.earned == 0) {
            delete userEarnings[msg.sender];
            break;
          }
          remaining = remaining.mul(2);
        }
        if (remaining <= earnedAmount) {
          userEarnings[msg.sender][i].amount = earnedAmount.sub(remaining);
          break;
        } else {
          delete userEarnings[msg.sender][i];
          remaining = remaining.sub(earnedAmount);
        }
      }
    }

    uint256 adjustedAmount = amount.add(penaltyAmount);
    bal.total = bal.total.sub(adjustedAmount);
    totalSupply = totalSupply.sub(adjustedAmount);
    stakingToken.safeTransfer(msg.sender, amount);
    if (penaltyAmount > 0) {
      incentivesController.claim(address(this), new address[](0));
      _notifyReward(address(stakingToken), penaltyAmount);
    }
    emit Withdrawn(msg.sender, amount, penaltyAmount);
  }

  function _getReward(address[] memory _rewardTokens) internal {
    uint256 length = _rewardTokens.length;
    for (uint256 i; i < length; i++) {
      address token = _rewardTokens[i];
      uint256 reward = rewards[msg.sender][token].div(1e12);
      if (token != address(stakingToken)) {
        
        
        Reward storage r = rewardData[token];
        uint256 periodFinish = r.periodFinish;
        require(periodFinish > 0, "Unknown reward token");
        uint256 balance = r.balance;
        if (periodFinish < block.timestamp.add(rewardsDuration - 86400)) {
          uint256 unseen = IERC20(token).balanceOf(address(this)).sub(balance);
          if (unseen > 0) {
            _notifyReward(token, unseen);
            balance = balance.add(unseen);
          }
        }
        r.balance = balance.sub(reward);
      }
      if (reward == 0) continue;
      rewards[msg.sender][token] = 0;
      IERC20(token).safeTransfer(msg.sender, reward);
      emit RewardPaid(msg.sender, token, reward);
    }
  }

  
  function getReward(address[] memory _rewardTokens) public {
    _updateReward(msg.sender);
    _getReward(_rewardTokens);
  }

  
  function exit(bool claimRewards) external {
    require(userEarnings[msg.sender].length == 0 || block.timestamp > vestingLockTimestamp, "Vested token owner must exit after the required lock timestamp");
    _updateReward(msg.sender);
    (uint256 amount, uint256 penaltyAmount) = withdrawableBalance(msg.sender);
    delete userEarnings[msg.sender];
    Balances storage bal = balances[msg.sender];
    bal.total = bal.total.sub(bal.unlocked).sub(bal.earned);
    bal.unlocked = 0;
    bal.earned = 0;

    totalSupply = totalSupply.sub(amount.add(penaltyAmount));
    stakingToken.safeTransfer(msg.sender, amount);
    if (penaltyAmount > 0) {
      incentivesController.claim(address(this), new address[](0));
      _notifyReward(address(stakingToken), penaltyAmount);
    }
    if (claimRewards) {
      _getReward(rewardTokens);
    }
    emit Withdrawn(msg.sender, amount, penaltyAmount);
  }

  
  function withdrawExpiredLocks() external {
    _updateReward(msg.sender);
    LockedBalance[] storage locks = userLocks[msg.sender];
    Balances storage bal = balances[msg.sender];
    uint256 amount;
    uint256 length = locks.length;
    if (length == 0) return;
    if (locks[length - 1].unlockTime <= block.timestamp) {
      amount = bal.locked;
      delete userLocks[msg.sender];
    } else {
      for (uint256 i = 0; i < length; i++) {
        if (locks[i].unlockTime > block.timestamp) break;
        amount = amount.add(locks[i].amount);
        delete locks[i];
      }
    }
    bal.locked = bal.locked.sub(amount);
    bal.total = bal.total.sub(amount);
    totalSupply = totalSupply.sub(amount);
    lockedSupply = lockedSupply.sub(amount);
    stakingToken.safeTransfer(msg.sender, amount);
    emit Withdrawn(msg.sender, amount, 0);
  }

  

  function _notifyReward(address _rewardsToken, uint256 reward) internal {
    Reward storage r = rewardData[_rewardsToken];
    if (block.timestamp >= r.periodFinish) {
      r.rewardRate = reward.mul(1e12).div(rewardsDuration);
    } else {
      uint256 remaining = r.periodFinish.sub(block.timestamp);
      uint256 leftover = remaining.mul(r.rewardRate).div(1e12);
      r.rewardRate = reward.add(leftover).mul(1e12).div(rewardsDuration);
    }

    r.lastUpdateTime = block.timestamp;
    r.periodFinish = block.timestamp.add(rewardsDuration);
  }

  
  function recoverERC20(address tokenAddress, uint256 tokenAmount) external onlyOwner {
    require(tokenAddress != address(stakingToken), "Cannot withdraw staking token");
    require(rewardData[tokenAddress].lastUpdateTime == 0, "Cannot withdraw reward token");
    IERC20(tokenAddress).safeTransfer(owner(), tokenAmount);
    emit Recovered(tokenAddress, tokenAmount);
  }

  function _updateReward(address account) internal {
    address token = address(stakingToken);
    uint256 balance;
    Reward storage r = rewardData[token];
    uint256 rpt = _rewardPerToken(token, lockedSupply);
    r.rewardPerTokenStored = rpt;
    r.lastUpdateTime = lastTimeRewardApplicable(token);
    if (account != address(this)) {
      
      rewards[account][token] = _earned(account, token, balances[account].locked, rpt);
      userRewardPerTokenPaid[account][token] = rpt;
      balance = balances[account].total;
    }

    uint256 supply = totalSupply;
    uint256 length = rewardTokens.length;
    for (uint256 i = 1; i < length; i++) {
      token = rewardTokens[i];
      r = rewardData[token];
      rpt = _rewardPerToken(token, supply);
      r.rewardPerTokenStored = rpt;
      r.lastUpdateTime = lastTimeRewardApplicable(token);
      if (account != address(this)) {
        rewards[account][token] = _earned(account, token, balance, rpt);
        userRewardPerTokenPaid[account][token] = rpt;
      }
    }
  }

  

  event RewardAdded(uint256 reward);
  event Staked(address indexed user, uint256 amount, bool locked);
  event Withdrawn(address indexed user, uint256 receivedAmount, uint256 penaltyPaid);
  event RewardPaid(address indexed user, address indexed rewardsToken, uint256 reward);
  event RewardsDurationUpdated(address token, uint256 newDuration);
  event Recovered(address token, uint256 amount);
}