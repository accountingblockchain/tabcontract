pragma solidity ^0.4.18;


import "../ownership/Ownable.sol";


/**
 * @title Lockable
 * @dev Base contract which allows children to lock and unlock the ability for addresses to make transfers
 */
contract Lockable is Ownable {

  mapping (address => bool) public lockStates;   // map between addresses and their lock state.

  event Lock(address indexed accountAddress);
  event Unlock(address indexed accountAddress);


  /**
   * @dev Modifier to make a function callable only when the account is in unlocked state
   */
  modifier whenNotLocked(address _address) {
    require(!lockStates[_address]);
    _;
  }

  /**
   * @dev Modifier to make a function callable only when the acount is in locked state
   */
  modifier whenLocked(address _address) {
    require(lockStates[_address]);
    _;
  }

  /**
   * @dev called by the owner to lock the ability for an address to make transfers
   */
  function lock(address _address) onlyOwner public {
      lockWorker(_address);
  }

  function lockMultiple(address[] _addresses) onlyOwner public {
      for (uint i=0; i < _addresses.length; i++) {
          lock(_addresses[i]);
      }
  }

  function lockWorker(address _address) internal {
      require(_address != owner);
      require(this != _address);

      lockStates[_address] = true;
      Lock(_address);
  }

  /**
   * @dev called by the owner to unlock an address in order for it to be able to make transfers
   */
  function unlock(address _address) onlyOwner public {
      unlockWorker(_address);
  }

  function unlockMultiple(address[] _addresses) onlyOwner public {
      for (uint i=0; i < _addresses.length; i++) {
          unlock(_addresses[i]);
      }
  }

  function unlockWorker(address _address) internal {
      lockStates[_address] = false;
      Unlock(_address);
  }
}
