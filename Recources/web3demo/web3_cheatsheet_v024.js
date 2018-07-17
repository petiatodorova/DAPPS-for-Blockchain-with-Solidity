//More info on: https://github.com/ethereum/wiki/wiki/JavaScript-API


//if you're using node.js, you need to load the Web3 library
var Web3 = require("web3");
//create a web3 instance - one that is connected to a local node
//the port (9545) may be different depending on your local node. This works for Truffle
var web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8545"));

//getting the web3 version
web3.version.api

//getting an array of the node's accounts
web3.eth.accounts

var acc = web3.eth.accounts[0]; //get the first account
var otherAcc = web3.eth.accounts[1];

//We will use the "web3_cheatsheet_contract.sol" contract.

//Store this contract's compiled bytecode and ABI
var abi = []
var bytecode = ""

//create the contract instance. We can use this instance to publish or connect to a published contract
var Contract = web3.eth.contract(abi);

//create a JS Object (key-value pairs), holding the data we need to publish our contract
var publishData = {
	"from": acc, //the account from which it will be published
	"data": bytecode,
	"gas": 4000000 //gas limit. This should be the same or lower than Ethereum's gas limit
}

//publish the contract, passing a callback that will be called twice. Once when the transaction is sent, and once when it is mined
//the first argument is the constructor argument
Contract.new("123456789123456789", publishData, function(err, contractInstance) {
	if(!err) {
		if(contractInstance.address) { //if the contract has an address aka if the transaction is mined
			console.log("New contract address is :", contractInstance.address);
		}
	} else {
		console.error(err); //something went wrong
	}
});


var contractAdr = "0x123" //replace with real address
//create our contract instance - a connection to a published contract
var contractInstance = Contract.at(contractAdr);

//let's call its "setA" method with the value 123.
//We will pass a callback which will be called when the transaction is mined
contractInstance.setState("123", {"from": acc}, function(err, res) {
	if(!err){
		console.log("Successfully set A to 123!");
	}
});

//let's get the value of a
contractInstance.getState.call({"from": acc}, function(err, res) {
	if(!err){
		//type of res is BigNumber. We can convert to string via .valueOf()
		console.log("The value of A is ", res.valueOf());
	}
})

//we can also call contract functions synchronously.
//This function will return when the call is done or the transaction is mined
var txHash = contractInstance.setState("123456789123456789", {"from": acc});

var res = contractInstance.getState.call({"from": acc});
console.log("A is now ", res.valueOf()); // "123456789123456789"

//let's call the setter from another account. This should fail (we're not the owner)
contractInstance.setState("123", {"from": otherAcc}, function(err, res) {
	if(!err){
		console.log("How is this possible?");
	} else {
		console.error(err); //Error: VM Exception while processing transaction: revert
	}
})

//let's call a payable contract method
//notice how we convert ethers to wei
contractInstance.add("456", {"from": acc, "value": web3.toWei(2, "ether")}, function(err, res){
	if(!err){
		console.log(res.valueOf()); //this will be the TX hash.
		//Web3 cannot access return values from transaction calls!
	} else {
		console.log("Not enough wei!");
	}
});

//let's filter the blockchain for contract events. 
//the callback will be called one event at a time.
//It will scan the whole blockchain for historical events and also watch for new upcoming events
var filterObject = contractInstance.allEvents({fromBlock: 0, toBlock: 'latest'}, function(error, result){
	if (!error){
		console.log("Got log: ", result);
		//result.event -> the name of the event
		//result.args -> parameters of the event
	}
});
//we can also use
//contractInstance.LogSetState(..., ...);
//if we are looking for a certain event


//More info on how to filter logs by the value of an indexed parameter: https://github.com/ethereum/wiki/wiki/JavaScript-API#contract-events

