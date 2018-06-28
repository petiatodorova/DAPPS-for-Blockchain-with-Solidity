# SmartContractsDevelopment
Smart contracts development with Solidity

# Homework Problems 20/06/2018

### Problem 1. Improve the auction contract
Use the Auction contract that we implemented in the lab and add the following functionality:
Add functionality which requires a minimum bid difference between the highest bid and the new bid. For example: the current bid is 5 the next minimum bid is 10, then 15, 20… etc..
The value of the bid margin should be included in the constructor
If someone has place a bid, he can do it again after 1 hour. 

### Problem 2. Service marketplace
Create a contract, that:
Has a method to buy a certain service. The service costs 1 ETH.
If the money sent are more than 1ETH, the contract will return the extra back.
The contract confirms that the person bought the service by emitting an event.
Nobody can buy the service for 2 minutes after someone bought it. Use a custom function modifier for that.
Use assert and require whenever possible.
The owner of the contract can withdraw the money once per hour and maximum of 5 ETH at a time.

# Homework Problems 13/06/2018

### Problem 1. Bad Coding Task or Why Loops are “Forbidden”
Write a smart contract to calculate the factorial of a given number. Create two different solutions (iterative and recursive)
Do you observe any obvious problems?
How to prevent it?
Compare both solutions

### Problem 2. Random number generation
Write a smart contract which provides a function that generates a random number. For that purpose you must use all appropriate (in your opinion) properties from 42 and 43 slides. 
