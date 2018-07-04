pragma solidity ^0.4.24;

contract Courses {
    struct Instructor {
        uint age;
        string fName;
        string lName;
    }

    mapping(address => Instructor) instructors;

    address[] public InstructorAccounts;

    constructor(
       uint _age,
       string _fName,
       string _lName)
       public
       {
           // Fills up 1 instructor
           instructors[msg.sender].age = _age;
           instructors[msg.sender].fName = _fName;
           instructors[msg.sender].lName = _lName;

           // Fills up the instructor's array
           InstructorAccounts.push(msg.sender);
       }

       function getInstuctors() public view returns(address[]) {
           return InstructorAccounts;
       }

       function getNumberInstructors() public view returns(uint) {
           return InstructorAccounts.length;
       }

}
