pragma solidity 0.4.19;

contract Owned {
    address public owner;
    
    function Owned() public {
        owner = msg.sender;
    }
    
    modifier OnlyOwner{
        require(msg.sender == owner);
        _;
    }
}

contract SafeAddUint8 {
    //library that can safely add uint8s by checking for overflow
    function add(uint8 a, uint8 b) internal pure returns (uint8) {
        uint8 c = a + b;
        assert(c >= a);
        return c;
    }
}pragma solidity 0.4.24;

contract s1 
{
    string public a;
    
    function test()
    {   
        a = "s1";
    }
}

contract s2
{
    string public a;
    
    function test()
    {   
        a = "s2";
    }
}

contract s3 is s2 
{
    function test()
    {   
        a = "s3";
    }
}

contract s4 is s2 
{
    function test()
    {   
        a = "s4";
    }
}

contract s5 is s4
{
    function test()
    {   
        a = "s5";
    }
}

contract s6 is s1, s2, s3, s5
{
    function test()
    {   
        super.test();
    }
}




//inheriting both contracts
contract OwnerCounter is Owned, SafeAddUint8{
    uint8 public counter;
    function OwnerCounter() public {
        reset();
    }
    
    function reset() public {
        counter = 0;
    }
    
    function addToCounter(uint8 b) public OnlyOwner {
        counter = add(counter, b);
    }
}
