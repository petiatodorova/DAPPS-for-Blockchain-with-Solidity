// If you're using node.js, you need to load the Web3 library
var Web3 = require("web3");

// Create a web3 instance - one that is connected to a local node
// the port (7545) may be different depending on your local node. This works for Ganache

// var web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8545"));
var web3 = new Web3(new Web3.providers.WebsocketProvider('http://127.0.0.1:8545'));

// Getting the web3 version
web3.version

var accountsArray;
// Getting an array of the node's accounts
web3.eth.getAccounts(function(error, result) {
	if(!error) {
		accountsArray = result;
	}
});

var currentAccount = accountsArray[0]; //get the first account
var otherAccount = accountsArray[1];

const txProperties = {
	"from": currentAccount,
	"to": otherAccount,
	"value": 2*1e18
}

web3.eth.sendTransaction(txProperties);

web3.eth.getBlock(1, function(err, res) {
	if(!err){
		//type of res is BigNumber. We can convert to string via .valueOf()
		console.log("Block properties: ", res);
	}
	else  {
		// error handling
	}
});

web3.eth.getTransaction('0xcd534d90a3f6530c4138f1ed70c99f2bc4b464273b225c6c3f95039d195261a7', function(err, res) {
	if(!err){
		//type of res is BigNumber. We can convert to string via .valueOf()
		console.log("Transaction: ", res);
}
});

// We will use the "web3_cheatsheet_contract.sol" contract.

//Store this contract's compiled bytecode and ABI
var abi = [
	{
		"constant": false,
		"inputs": [
			{
				"name": "incrementBy",
				"type": "uint256"
			}
		],
		"name": "count",
		"outputs": [
			{
				"name": "",
				"type": "uint256"
			},
			{
				"name": "",
				"type": "uint256"
			}
		],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [],
		"name": "getCounter",
		"outputs": [
			{
				"name": "",
				"type": "uint256"
			},
			{
				"name": "",
				"type": "uint256"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [],
		"name": "owner",
		"outputs": [
			{
				"name": "",
				"type": "address"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [
			{
				"name": "newOwner",
				"type": "address"
			}
		],
		"name": "transferOwnership",
		"outputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": true,
				"name": "previousOwner",
				"type": "address"
			},
			{
				"indexed": true,
				"name": "newOwner",
				"type": "address"
			}
		],
		"name": "OwnershipTransferred",
		"type": "event"
	}
]

var bytecode = "608060405260006001556000600255336000806101000a81548173ffffffffffffffffffffffffffffffffffffffff021916908373ffffffffffffffffffffffffffffffffffffffff1602179055506103c18061005d6000396000f300608060405260043610610062576000357c0100000000000000000000000000000000000000000000000000000000900463ffffffff1680633b3546c8146100675780638ada066e146100af5780638da5cb5b146100e1578063f2fde38b14610138575b600080fd5b34801561007357600080fd5b506100926004803603810190808035906020019092919050505061017b565b604051808381526020018281526020019250505060405180910390f35b3480156100bb57600080fd5b506100c461020a565b604051808381526020018281526020019250505060405180910390f35b3480156100ed57600080fd5b506100f661021b565b604051808273ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200191505060405180910390f35b34801561014457600080fd5b50610179600480360381019080803573ffffffffffffffffffffffffffffffffffffffff169060200190929190505050610240565b005b6000806000809054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff163373ffffffffffffffffffffffffffffffffffffffff161415156101d957600080fd5b8260026000828254019250508190555060016000815480929190600101919050555060015460025491509150915091565b600080600154600254915091509091565b6000809054906101000a900473ffffffffffffffffffffffffffffffffffffffff1681565b6000809054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff163373ffffffffffffffffffffffffffffffffffffffff1614151561029b57600080fd5b600073ffffffffffffffffffffffffffffffffffffffff168173ffffffffffffffffffffffffffffffffffffffff16141515156102d757600080fd5b8073ffffffffffffffffffffffffffffffffffffffff166000809054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff167f8be0079c531659141344cd1fd0a4f28419497f9722a3daafe3b4186f6b6457e060405160405180910390a3806000806101000a81548173ffffffffffffffffffffffffffffffffffffffff021916908373ffffffffffffffffffffffffffffffffffffffff160217905550505600a165627a7a723058204462ed52a345bae6f12160f2dcf1b631d02e6ab000ba4774cd86f8de459de4a50029";


//create the contract instance. We can use this instance to publish or connect to a published contract
var myContract = new web3.eth.Contract(abi, null, {
    data: bytecode
});

var contractInstance;

myContract.deploy().send({
    from: currentAccount,
	gasPrice: 4000000,
	gas: 1500000,
}).then((instance) => {
    console.log("Contract mined at " + instance.options.address);
    contractInstance = instance;
});


// Let's call its "setA" method with the value 123.
// We will pass a callback which will be called when the transaction is mined
contractInstance.methods.count(5).send({"from": currentAccout}, function(err, res) {
	if(!err){
		console.log("Successfully");
}
});

// Let's get the value of a
contractInstance.methods.transferOwnership().call({"from": currentAccount}, function(err, res) {
	if(!err){
		//type of res is BigNumber. We can convert to string via .valueOf()
		console.log("The value of the state is: ", res);
}
});

// Let's call the setter from another account. This should fail (we're not the owner)
contractInstance.methods.setState(123).send({"from": otherAccount}, function(err, res) {
	if(!err){
		console.log("How is this possible?");
} else {
		console.error(err); //Error: VM Exception while processing transaction: revert
	}
})

//let's call a payable contract method
//notice how we convert ethers to wei
contractInstance.methods.add(5).send({"from": currentAccout, "value": 2*1e18}, function(err, res){
	if(!err){
		console.log(res.valueOf()); //this will be the TX hash.
		// Web3 cannot access return values from transaction calls!
	} else {
		console.log("Not enough Ethers!");
}
});

//let's filter the blockchain for contract events.
//the callback will be called one event at a time.
//It will scan the whole blockchain for historical events and also watch for new upcoming events
var filterObject = contractInstance.events.allEvents({fromBlock: 0, toBlock: 'latest'}, function(error, result){
	if (!error){
		console.log("Got log: ", result);
		//result.event -> the name of the event
		//result.args -> parameters of the event
	}
});
