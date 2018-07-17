pragma solidity ^0.4.24;

contract ArithmeticOperations {
    
    int public a = 2**3 + 1;
    
    int public b = a++;
    
    int public c = ++a;
    
    int public d = a / 3;
    
    int public  e = a % 3;
}
