pragma solidity ^0.4.24;

contract Courses {
    struct Instructor {
        uint age;
        string fName;
        string lName;
    }

    mapping(address => Instructor) instructors;

    address[] public InstructorAccounts;

    function setInstructor(
       address _address,
       uint _age,
       string _fName,
       string _lName)
       public
       {
           // Fills up 1 instructor
           instructors[_address].age = _age;
           instructors[_address].fName = _fName;
           instructors[_address].lName = _lName;

           // Fills up the instructor's array
           InstructorAccounts.push(_address);
       }

       function getInstuctors() public view returns(address[]) {
           return InstructorAccounts;
       }

       function getNumberInstructors() public view returns(uint) {
           return InstructorAccounts.length;
       }
}
