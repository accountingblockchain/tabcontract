pragma solidity ^0.4.18;

import "../ownership/Ownable.sol";

/**
 * @title PurchaseLimiter
 * @dev Base contract which allows changing of how much ether is worth in relation to USD
 */
contract RateManager is Ownable {
  event RateChanged(uint256 _old, uint256 _new);

  uint256 public oneEtherUsdPrice = 1000;

  function setOneEtherUsdPrice(uint256 newAmount) public onlyOwner {
    require(newAmount > 0);
    uint256 oldAmount = oneEtherUsdPrice;
    oneEtherUsdPrice = newAmount;
    RateChanged(oldAmount, newAmount);
  }
}