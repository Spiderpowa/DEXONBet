pragma solidity ^0.4.25;

import "openzeppelin-solidity/contracts/ownership/Ownable.sol";
import "openzeppelin-solidity/contracts/math/SafeMath.sol";

contract DEXONBet is Ownable {
  using SafeMath for uint;

  uint public expectation;
  uint[100] public payout;

  event Bet (
    address indexed _addr,
    uint _target,
    uint _value,
    uint _pay
  );

  constructor(uint _expectation) public {
    updateExpectation(_expectation);
  }

  // Expectation = ProbWin * Payout.
  // Payout = Expectation / ProbWin.
  function updateExpectation(uint _expectation) public onlyOwner {
    require(_expectation < 100, "Expectation should be less than 100.");
    expectation = _expectation;
    uint exp = _expectation.mul(10000);
    uint[100] memory newPayout;
    newPayout[0] = 0;
    for (uint i = 1; i < 100; i++) {
      newPayout[i] = exp.div(i);
    }
    payout = newPayout;
  }

  function bet(uint _target) external payable {
    require(_target > 1, "Target should be bigger.");
    require(_target <= expectation, "Target should be smaller.");
    require(msg.value > 10000, "Minimum bet is 10000.");
    uint value = rand % 100 + 1;
    uint pay = 0;
    if (value < _target) {
      pay = msg.value.mul(payout[_target-1]).div(10000);
      msg.sender.transfer(pay);
    }
    emit Bet(msg.sender, _target, msg.value, pay);
  }

  function claim(uint _amount) external onlyOwner {
    require(_amount <= address(this).balance, "No enough of token to claim.");
    owner().transfer(_amount);
  }

  function donate() external payable {}

}