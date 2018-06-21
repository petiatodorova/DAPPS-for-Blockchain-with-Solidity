pragma solidity ^0.4.24;

contract Random {
    function RandomNumber() public returns(uint256) {
        uint256 a = now ** 29 % 52 + now ** 3;
        return a;
    }

    function RandomNumber1() public returns(uint256) {
        uint256 b = now ** 29 % (2**59) + now * 3;
        return b;
    }

    function TheNumber(uint256 a, uint256 b) public returns(uint256) {
        uint256 number = RandomNumber() + uint256(block.blockhash(block.number-1));
        uint256 number1 = RandomNumber1() - uint256(block.blockhash(block.number-2));
        return number * number1;
    }
}
