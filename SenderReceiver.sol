pragma solidity ^0.4.24;

contract Sender {
    address owner;

	constructor() public payable {
		owner = msg.sender;
	}

	event SendedMoney (address _to, uint _value);

	modifier positiveBalance() {
	    require(owner.balance >= msg.value);
	    _;
	}

	function returnOwner() public view returns(address) {
	    return owner;
	}

  function transferMoney(address _receiver)
     public
     positiveBalance()
     payable
  {
    _receiver.transfer(msg.value);
    emit SendedMoney(_receiver, msg.value);
  }
}


contract Receiver {
  uint public balance;
  address receiver;

  constructor() public {
      receiver = msg.sender;
      balance = msg.sender.balance;
  }

  event Receive(uint value);

  function () public payable {
    emit Receive(msg.value);
  }
}
