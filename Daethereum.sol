pragma solidity ^0.4.24;



contract Daethereum is StandardToken {
  string public constant name = "Daethereum";
  string public constant symbol = "DTHR";
  uint32 public constant decimals = 8;
  uint256 public INITIAL_SUPPLY = 100000000 * 10 ** 8;
  constructor() public {
    totalSupply_ = INITIAL_SUPPLY;
    balances[msg.sender] = INITIAL_SUPPLY;
    emit Transfer(0x0, msg.sender, INITIAL_SUPPLY);
  }
}
