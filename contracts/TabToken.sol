pragma solidity ^0.4.18;


import "./token/ERC20/ERC20.sol";
import "./token/ERC20/BasicToken.sol";
import "./token/ERC20/PausableToken.sol";
import "./token/ERC20/StandardToken.sol";
import "./token/ERC20/BurnableToken.sol";
import "./lifecycle/Lockable.sol";
import "./math/SafeMath.sol";

/*
  ERC20 TAB Token smart contract implementation
*/
contract TabToken is PausableToken, Lockable {

  event Burn(address indexed burner, uint256 value);
  event EtherReceived(address indexed sender, uint256 weiAmount);
  event EtherSent(address indexed receiver, uint256 weiAmount);
  event EtherAddressChanged(address indexed previousAddress, address newAddress);

  
  string public constant name = "TAB";
  string public constant symbol = "TAB";
  uint8 public constant decimals = 18;


  address internal _etherAddress = 0x90CD914C827a12703D485E9E5fA69977E3ea866B;

  //This is already exposed from BasicToken.sol as part of the standard
  uint256 internal constant INITIAL_SUPPLY = 22000000000;

  /**
   * @dev Constructor that gives msg.sender all of existing tokens.
   */
  function TabToken() public {
    totalSupply_ = INITIAL_SUPPLY;

    //Give all initial supply to the contract.
    balances[this] = INITIAL_SUPPLY;
    Transfer(0x0, this, INITIAL_SUPPLY);

    //From now onwards, we MUST always use transfer functions
  }

  //Fallback function - just revert any payments
  function () payable public {
    revert();
  }

  //Function which allows us to fund the contract with ether
  function fund() payable public onlyOwner {
    require(msg.sender != 0x0);
    require(msg.value > 0);

    EtherReceived(msg.sender, msg.value);
  }

  //Function which allows sending ether from contract to the hard wallet address
  function sendEther() payable public onlyOwner {
    require(msg.value > 0);
    assert(_etherAddress != address(0));     //This should never happen

    EtherSent(_etherAddress, msg.value);
    _etherAddress.transfer(msg.value);
  }

  //Get the total wei in contract
  function totalBalance() view public returns (uint256) {
    return this.balance;
  }
  
  function transferFromContract(address[] _addresses, uint256[] _values) public onlyOwner returns (bool) {
    require(_addresses.length == _values.length);
    
    for (uint i=0; i < _addresses.length; i++) {
      require(_addresses[i] != address(0));
      require(_values[i] <= balances[this]);

      // SafeMath.sub will throw if there is not enough balance.
      balances[this] = balances[this].sub(_values[i]);
      balances[_addresses[i]] = balances[_addresses[i]].add(_values[i]);
      Transfer(msg.sender, _addresses[i], _values[i]);

    }
    
    return true;
  }

  function remainingSupply() public view returns(uint256) {
    return balances[this];
  }

  /**
   * @dev Burns a specific amount of tokens from the contract
   * @param amount The amount of token to be burned.
   */
  function burnFromContract(uint256 amount) public onlyOwner {
    require(amount <= balances[this]);
    // no need to require value <= totalSupply, since that would imply the
    // sender's balance is greater than the totalSupply, which *should* be an assertion failure

    address burner = this;
    balances[burner] = balances[burner].sub(amount);
    totalSupply_ = totalSupply_.sub(amount);
    Burn(burner, amount);
  } 

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
