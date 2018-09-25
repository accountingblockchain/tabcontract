pragma solidity ^0.4.18;


import "../ownership/Ownable.sol";


/**
 * @title Pausable
 * @dev Base contract which allows or disallows buying of tokens
 */
contract Purchasable is Ownable {
  event EnableTokenPurchasing();
  event DisableTokenPurchasing();

  //Make contract purchasable by default
  bool public purchasable = true;


  /**
   * @dev Modifier to make a function callable only when the contract is not purchasable.
   */
  modifier whenNotPurchasable() {
    require(!purchasable);
    _;
  }

  /**
   * @dev Modifier to make a function callable only when the contract is purchasable.
   */
  modifier whenPurchasable() {
    require(purchasable);
    _;
  }

  /**
   * @dev called by the owner to enable functionality to buy tokens, triggers stopped state
   */
  function makePurchasable() onlyOwner whenNotPurchasable public {
    purchasable = true;
    EnableTokenPurchasing();
  }

  /**
   * @dev called by the owner to disable functionality to buy tokens, returns to normal state
   */
  function makeUnpurchasable() onlyOwner whenPurchasable public {
    purchasable = false;
    DisableTokenPurchasing();
  }
}