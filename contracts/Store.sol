pragma solidity ^0.4.18;

contract SimpleStorage {
  uint myVariable;
  uint myVariable2;

  function set(uint x) public {
      myVariable = 10;
  }

  function get() constant public returns (uint) {
    return myVariable;
  }
}