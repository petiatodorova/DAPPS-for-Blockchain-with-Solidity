pragma solidity ^0.4.24;

contract FactorialRecursive {
    function factorialRecursive(uint256 number) public returns(uint256) {
        if (number == 0 || number == 1) {
            return 1;
        } else {
            return number * factorialRecursive(number - 1);
        }
    }
}