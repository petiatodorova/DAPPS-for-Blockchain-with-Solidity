pragma solidity ^0.4.24;

contract BooleanOperations {
    
    bool public a = true;
    
    bool public b = false;
    
    bool public c = a || b;
    
    bool public d = a && b;
    
    bool public e = (d == c);
    
    bool public f = (d != c);
    
    bool public g = !f;
}