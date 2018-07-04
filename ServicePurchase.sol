pragma solidity ^0.4.24;

contract ServicePurchase {
    address public owner;
    uint256 timeLimit;
    uint256 serviceCost = 1 ether;
    uint256 ownerCurrentWithdraw;
    uint256 restMoney;

    constructor()
        public
    {
        owner = msg.sender;
    }

    // checks if this is the owner's address
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    // checks if this is the buyer's address
    modifier onlyBuyer() {
        require (msg.sender != owner);
        _;
    }

    // checks if the value of the transaction is bigger than the serviceCost
    modifier validValue() {
        require (msg.value > serviceCost);
        _;
    }

    // checks for 2 minutes
    modifier validTime() {
        require (now > timeLimit + 120 seconds);
        _;
    }

    // event for the purchase
    event PurchaseConfirmed(address buyer);

    // the payment
    function payment()
        public
        payable
        onlyBuyer
        validTime
        validValue
    {
        // buyer sends the serviceCost to the owner
        msg.sender.transfer(msg.value);

        // emit an event for the payment
        emit PurchaseConfirmed(msg.sender);
    }

    // withdrawal of money from the buyer,
    // if there is a positive difference after payment
    function buyerWithdraw()
        public
        payable
        onlyBuyer
        validValue
    {
        // calculates the money difference after the payment
        restMoney = msg.value - serviceCost;

        // check if there is some value for refund
        require(restMoney > 0);

        // the buyer withdraws the difference
        msg.sender.transfer(restMoney);
    }

    // withdrawal of money from the owner
    function ownerWithdraw()
        public
        payable
        onlyOwner
        {
            uint amountWanted;

            require ((now > timeLimit + 60 minutes) && amountWanted <= 5 ether);
            msg.sender.transfer(amountWanted);
            timeLimit = now;
        }
}
