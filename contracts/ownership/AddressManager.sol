pragma solidity ^0.4.18;


import "./Ownable.sol";
import "../lifecycle/Lockable.sol";

/**
 * @title AddressManager
 * @dev Contract which allows owner to make changes to addresses
 */
contract AddressManager is Ownable, Lockable {

  event EtherAddressChanged(address indexed previousAddress, address newAddress);

  address internal _etherAddress = 0xdd870fa1b7c4700f2bd7f44238821c26f7392148;

  function etherAddress() public view onlyOwner returns(address) {
    return _etherAddress;
  }

  //Function which enables owner to change address which is storing the ether
  function setEtherAddress(address newAddress) public onlyOwner {
    require(newAddress != address(0));
    EtherAddressChanged(_etherAddress, newAddress);
    _etherAddress = newAddress;
  }
}
