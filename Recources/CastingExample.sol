pragma solidity ^0.4.23;

contract ExplicitCasting {
    
    uint8 public a = 100;
    
    int8 public b = int8 (a);
    
    uint8 public c = 150;
    
    int8 public d = int8 (c);
    
    int8 public e = -5;
    
    uint8 public f = uint8 (e);

}
