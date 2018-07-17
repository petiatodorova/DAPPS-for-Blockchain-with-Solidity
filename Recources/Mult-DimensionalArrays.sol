pragma solidity 0.4.24

contract MultiDim{

    uint[][] public state; //works
    
    //UnimplementedFeatureError
    constructor(uint[][] _state) public {
	
        //can't pass multi dim arrays as aruments yet
        state = _state;
    }
    
    //works
    function append(uint[] arr){
        state.push(arr);
    }
    
    //UnimplementedFeatureError
    function getState() public returns (uint[][]){
	
        //can't return multi dim arrays yet
        return state;
    }
}