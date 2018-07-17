pragma solidity ^0.4.23;

contract LoopExample {
    
    uint public a;
    
    function TestForLoop() public {
        for(uint i = 0; i < 10; i++){
            a += i;
        }
    }
    
    function TestWhileLoop() public {
        while(a >= 3) {
            a--;
        }   
    }
}