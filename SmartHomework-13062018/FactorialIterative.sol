pragma solidity ^0.4.24;

contract FactorialIterative {
    
    function factorialIterative(uint256 number) public returns(uint256) {
        uint256 result = 1;
        if (number == 0 || number == 1) {
            result = 1;
        } else {
            for (uint i = 2; i <= number; i++ ) {
            result = result * i;
            }
        }
        
        return result;
    }
}