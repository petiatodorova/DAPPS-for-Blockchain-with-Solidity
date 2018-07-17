pragma solidity ^0.4.24;

contract Ownership {

    address public owner;
    address public proposedOwner;
    uint256 timeLimit;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    event OwnershipAccepted(address indexed newOwner);

    constructor()
        public 
        payable
    {
        owner = msg.sender;
    }

    modifier onlyOwner() 
    {
        require(msg.sender == owner);
        _;
    }
    
    modifier onlyProposedOwner()
    {
        require(msg.sender == proposedOwner);
        _;
    }

    function transferOwnership(address newOwner) 
        public 
        onlyOwner 
    {
        emit OwnershipTransferred(owner, newOwner);
        proposedOwner = newOwner;
        timeLimit = now;
    }
    
    function acceptOwnership() 
        public 
        onlyProposedOwner 
    {
        require(now < timeLimit + 30 seconds);
        emit OwnershipAccepted(msg.sender);
        owner = msg.sender;
    }
}