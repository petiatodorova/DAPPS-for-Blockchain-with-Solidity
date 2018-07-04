pragma solidity ^0.4.24;

contract Constr {

    address public owner;

    constructor () public {
        owner = msg.sender;
    }
}
