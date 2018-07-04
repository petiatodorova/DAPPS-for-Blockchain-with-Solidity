pragma solidity ^0.4.24;

contract ArrayConstructor {
    uint[] public myArray;

    constructor () public {
        myArray.push(11);
        myArray.push(32);
        myArray.push(378);
        myArray.push(78);
    }

    function getArrayLength() public view returns(uint) {
        return myArray.length;
    }

    function getThirdElement() public view returns(uint) {
        return myArray[2];
    }

    function returnMyArray() public view returns(uint[]) {
        return myArray;
    }

}
