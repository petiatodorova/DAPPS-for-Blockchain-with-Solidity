pragma solidity 0.4.24;


/**
 * @title Ownable
 * @dev The Ownable contract has an owner address, and provides basic authorization control
 * functions, this simplifies the implementation of "user permissions".
 */
contract Ownable {
    address public owner;


    event OwnershipRenounced(address indexed previousOwner);
    event OwnershipTransferred(
    address indexed previousOwner,
    address indexed newOwner
    );


  /**
   * @dev The Ownable constructor sets the original `owner` of the contract to the sender
   * account.
   */
    constructor() public {
        owner = msg.sender;
    }

  /**
   * @dev Throws if called by any account other than the owner.
   */
    modifier onlyOwner() {
        require(msg.sender == owner,
        "Only the owner of the market can operate!");
        _;
    }

  /**
   * @dev Allows the current owner to relinquish control of the contract.
   * @notice Renouncing to ownership will leave the contract without an owner.
   * It will not be possible to call the functions with the `onlyOwner`
   * modifier anymore.
   */
    function renounceOwnership() public onlyOwner {
        emit OwnershipRenounced(owner);
        owner = address(0);
    }

  /**
   * @dev Allows the current owner to transfer control of the contract to a newOwner.
   * @param _newOwner The address to transfer ownership to.
   */
    function transferOwnership(address _newOwner) public onlyOwner {
        _transferOwnership(_newOwner);
    }

  /**
   * @dev Transfers control of the contract to a newOwner.
   * @param _newOwner The address to transfer ownership to.
   */
  function _transferOwnership(address _newOwner) internal {
    require(_newOwner != address(0));
    emit OwnershipTransferred(owner, _newOwner);
    owner = _newOwner;
  }
}

/**
 * @title SafeMath
 * @dev Math operations with safety checks that throw on error
 */
library SafeMath {

  /**
  * @dev Multiplies two numbers, throws on overflow.
  */
  function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
    // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
    // benefit is lost if 'b' is also tested.
    // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
    if (a == 0) {
      return 0;
    }

    c = a * b;
    assert(c / a == b);
    return c;
  }

  /**
  * @dev Integer division of two numbers, truncating the quotient.
  */
  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    // assert(b > 0); // Solidity automatically throws when dividing by 0
    // uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold
    return a / b;
  }

  /**
  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
  */
  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    assert(b <= a);
    return a - b;
  }

  /**
  * @dev Adds two numbers, throws on overflow.
  */
  function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
    c = a + b;
    assert(c >= a);
    return c;
    }
}

contract Marketplace is Ownable {
    using SafeMath for uint;
    
    bool locked;
    
    // keeps the money earned from the sells
    uint earnedMoney;
    
    struct Product {
        string name;
        uint price;
        uint quantity;
    }
    
    // all products in the MarketPlace
    mapping(bytes32 => Product) products;

    // this array is for having a list of all available products
    // in our MarketPlace
    bytes32[] allProductHashes;

    // Events
    event PurchasedProduct(bytes32 indexed ID, uint indexed quantity, uint indexed remaining, address from);
    event OutOfStock(bytes32 indexed ID);
    event NewProduct(bytes32 indexed ID, string indexed name, uint indexed quantity, uint price);
    event Withdrawal(uint value, address _address);
    event SenderLogger(address _address);

    modifier noReentrancy() {
        require(!locked,
        "The product is locked right now. Please try again later!");
        locked = true;
        _;
        locked = false;
    }
    
    function getProductHashByName(string name) 
        public 
        view 
        returns(bytes32 ID) 
    {
        ID = keccak256(abi.encodePacked(name, owner));
    }

    function buy(bytes32 ID, uint quantity) 
        public 
        noReentrancy 
        payable 
    {
        require(products[ID].quantity >= quantity,
        "The product quantity is less than your desire. Please try with less quantity!");
        
        uint totalPrice = products[ID].price.mul(quantity);
        
        require(msg.value >= totalPrice,
        "Money is not enough to buy the product in such a quantity!");
        earnedMoney = earnedMoney.add(msg.value);
        products[ID].quantity = products[ID].quantity.sub(quantity);
        uint remainingQuantity = products[ID].quantity;
        
        emit PurchasedProduct(ID, quantity, remainingQuantity, msg.sender);
    }
    
    function update(bytes32 ID, uint newQuantity) 
        public 
        onlyOwner 
        noReentrancy 
    {
        products[ID].quantity = newQuantity;
        if (newQuantity < 5) {
            products[ID].quantity.add(100 finney);
        }
    }
    
    //creates a new product and returns its ID
    function newProduct(string name, uint price, uint quantity) 
        public 
        onlyOwner 
        returns(bytes32 ID) 
    {
        // Transforms the name into bytes32 ID
        ID = keccak256(abi.encodePacked(name, owner));
        
        // We put the ID in the array with all product hashes
        allProductHashes.push(ID);
        
        // We put the ID into our mapping and after that we set it's values
        Product storage product = products[ID];
        product.name = name;
        product.price = price;
        product.quantity = quantity;
        emit NewProduct(ID, name, quantity, price);
        return ID;
    }
    
    function getProduct(bytes32 ID) 
        public 
        view 
        returns(string name, uint price, uint quantity) 
    {
        return(products[ID].name, products[ID].price, products[ID].quantity);
    }
    
    // returns our allProductHashes[] with all products
    function getProducts() 
        public 
        view 
        returns(bytes32[]) 
    {
        return(allProductHashes);
    }
    
    function getPrice(bytes32 ID, uint quantity) 
        public 
        view 
        returns(uint) 
    {
        require(products[ID].quantity >= quantity,
        "You want too much quantity. Try with less!");
        uint totalPrice = products[ID].price.mul(quantity);
        return totalPrice;
    }

    function showEarnedMoney() 
        onlyOwner 
        public 
        view 
        returns(uint) 
    {
        return earnedMoney;
    }
    
    function withdraw(uint amount)
        onlyOwner
        public 
        payable 
    {
        require(earnedMoney >= amount);
        earnedMoney = earnedMoney.sub(amount);
        owner.transfer(amount);
    }

    // fallback function
    function() private payable {
       emit SenderLogger(msg.sender);
    }
}
