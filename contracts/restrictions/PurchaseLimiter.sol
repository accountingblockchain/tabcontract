pragma solidity ^0.4.18;

import "../ownership/Ownable.sol";

/**
 * @title PurchaseLimiter
 * @dev Base contract which allows changing purchase limitations
 */
contract PurchaseLimiter is Ownable {
  event MinWeiLimitChanged(uint256 _old, uint256 _new);
  event MaxWeiLimitChanged(uint256 _old, uint256 _new);

  uint256 public minWeiLimit = 100000000000000000;
  uint256 public maxWeiLimit = 10000000000000000000000;

  //Modifier to make a function callable only when the wei passed is within the limit
  modifier whenWeiWithinLimit() {
    require(msg.value >= minWeiLimit && msg.value <= maxWeiLimit);
    _;
  }

  function setMinWeiLimit(uint256 newAmount) public onlyOwner {
    require(newAmount < maxWeiLimit);
    require(minWeiLimit != newAmount);
    uint256 oldAmount = minWeiLimit;
    minWeiLimit = newAmount;
    MinWeiLimitChanged(oldAmount, minWeiLimit);
  }

  function setMaxWeiLimit(uint256 newAmount) public onlyOwner {
    require(newAmount > minWeiLimit);
    require(maxWeiLimit != newAmount);
    uint256 oldAmount = maxWeiLimit;
    maxWeiLimit = newAmount;
    MaxWeiLimitChanged(oldAmount, maxWeiLimit);
  }
}