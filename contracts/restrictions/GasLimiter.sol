pragma solidity ^0.4.18;

import "../ownership/Ownable.sol";

/**
 * @title MaxGasLimiter
 * @dev Base contract which allows changing gas limitations
 */
contract GasLimiter is Ownable {
  event MaxGasLimitChanged(uint256 _old, uint256 _new);

  uint256 public maxGasLimit = 300000;

  //Modifier to make a function callable only when the the gas used does not exceed our set limit
  modifier whenMaxGasLimitNotReached() {
    require(msg.gas <= maxGasLimit);
    _;
  }

  //Function which enables owner to change max gas limit
  function setMaxGasLimit(uint256 _gasLimit) public onlyOwner {
    uint256 oldMaxGasLimit = maxGasLimit;

    require(oldMaxGasLimit != _gasLimit);

    maxGasLimit = _gasLimit;
    MaxGasLimitChanged(oldMaxGasLimit, maxGasLimit);
  }
}