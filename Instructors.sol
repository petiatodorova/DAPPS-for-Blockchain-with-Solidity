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

           // Fills up instructors array
           InstructorAccounts.push(_address);
       }

       // view all instructoraddresses
       function getInstuctors() public view returns(address[]) {
           return InstructorAccounts;
       }

       // view number of instructors
       function getNumberInstructors() public view returns(uint) {
           return InstructorAccounts.length;
       }

       // view 1 instructor
       function getOneInstructor(address _address)
           public
           view
           returns(uint, string, string)
       {
               return (
                   instructors[_address].age,
                   instructors[_address].fName,
                   instructors[_address].lName
               );
       }

}
