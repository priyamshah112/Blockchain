pragma solidity >0.4.24;
//Coin handling Code
contract Coin {
	// The keyword "public" makes those variables
	// easily readable from outside.
	address public minter;
	mapping (address => uint) public balances;
	// Events allow light clients to react to
	// changes efficiently.
	event Sent(address from, address to, uint amount);
	// This is the constructor whose code is
	// run only when the contract is created.
	constructor() public {
		minter = msg.sender;
	}
	function mint(address receiver, uint amount) public {
		require(msg.sender == minter);
		require(amount < 1e60);
		balances[receiver] += amount;
	}
	function send(address receiver, uint amount) public {
		require(amount <= balances[msg.sender], "Insufficient balance.");
		balances[msg.sender] -= amount;
		balances[receiver] += amount;
		emit Sent(msg.sender, receiver, amount);
	}
}

contract Coin {
    address minter;
    mapping (address => uint) balances;
    function Coin() {
        minter = msg.sender;
    }
    function mint(address owner, uint amount) {
        if (msg.sender != minter) return;
        balances[owner] += amount;
    }
    function send(address receiver, uint amount) {
        if (balances[msg.sender] < amount) return;
        balances[msg.sender] -= amount;
        balances[receiver] += amount;
    }
    function queryBalance(address addr) constant returns (uint balance) {
        return balances[addr];
    }
}
//Arrays
contract ArrayContract {
  uint[2**20] m_aLotOfIntegers;
  bool[2][] m_pairsOfFlags;
  function setAllFlagPairs(bool[2][] newPairs) {
    // assignment to array replaces the complete array
    m_pairsOfFlags = newPairs;
  }
  function setFlagPair(uint index, bool flagA, bool flagB) {
    // access to a non-existing index will stop execution
    m_pairsOfFlags[index][0] = flagA;
    m_pairsOfFlags[index][1] = flagB;
  }
  function changeFlagArraySize(uint newSize) {
    // if the new size is smaller, removed array elements will be cleared
    m_pairsOfFlags.length = newSize;
  }
  function clear() {
    // these clear the arrays completely
    delete m_pairsOfFlags;
    delete m_aLotOfIntegers;
    // identical effect here
    m_pairsOfFlags.length = 0;
  }
  bytes m_byteData;
  function byteArrays(bytes data) external {
    // byte arrays ("bytes") are different as they are stored without padding,
    // but can be treated identical to "uint8[]"
    m_byteData = data;
    m_byteData.length += 7;
    m_byteData[3] = 8;
    delete m_byteData[2];
  }
}

//Structures
//CrowdFunding Code 
contract CrowdFunding {
  struct Funder {
    address addr;
    uint amount;
  }
  struct Campaign {
    address beneficiary;
    uint fundingGoal;
    uint numFunders;
    uint amount;
    mapping (uint => Funder) funders;
  }
  uint numCampaigns;
  mapping (uint => Campaign) campaigns;
  function newCampaign(address beneficiary, uint goal) returns (uint campaignID) {
    campaignID = numCampaigns++; // campaignID is return variable
    Campaign c = campaigns[campaignID];  // assigns reference
    c.beneficiary = beneficiary;
    c.fundingGoal = goal;
  }
  function contribute(uint campaignID) {
    Campaign c = campaigns[campaignID];
    Funder f = c.funders[c.numFunders++];
    f.addr = msg.sender;
    f.amount = msg.value;
    c.amount += f.amount;
  }
  function checkGoalReached(uint campaignID) returns (bool reached) {
    Campaign c = campaigns[campaignID];
    if (c.amount < c.fundingGoal)
      return false;
    c.beneficiary.send(c.amount);
    c.amount = 0;
    return true;
  }
  //Enums
  contract test {
    enum ActionChoices { GoLeft, GoRight, GoStraight, SitStill }
    ActionChoices choices;
    ActionChoices constant defaultChoice = ActionChoices.GoStraight;
    function setGoStraight()
    {
        choices = ActionChoices.GoStraight;
    }
    function getChoice() returns (uint)
    {
        return uint(choices);
    }
    function getDefaultChoice() returns (uint)
    {
        return uint(defaultChoice);
    }
}
//Contract to Contract calls
//Transfer of ownership and token generation code
contract OwnedToken {
  // TokenCreator is a contract type that is defined below. It is fine to reference it
  // as long as it is not used to create a new contract.
  TokenCreator creator;
  address owner;
  bytes32 name;
  function OwnedToken(bytes32 _name) {
    address nameReg = 0x72ba7d8e73fe8eb666ea66babc8116a41bfb10e2;
    nameReg.call("register", _name);
    owner = msg.sender;
    // We do an explicit type conversion from `address` to `TokenCreator` and assume that the type of
    // the calling contract is TokenCreator, there is no real way to check.
    creator = TokenCreator(msg.sender);
    name = _name;
  }
  function changeName(bytes32 newName) {
    // Only the creator can alter the name -- contracts are explicitly convertible to addresses.
    if (msg.sender == address(creator)) name = newName;
  }
  function transfer(address newOwner) {
    // Only the current owner can transfer the token.
    if (msg.sender != owner) return;
    // We also want to ask the creator if the transfer is fine.
    // Note that this calls a function of the contract defined below.
    // If the call fails (e.g. due to out-of-gas), the execution here stops
    // immediately (the ability to catch this will be added later).
    if (creator.isTokenTransferOK(owner, newOwner))
      owner = newOwner;
  }
}
contract TokenCreator {
  function createToken(bytes32 name) returns (address tokenAddress) {
    // Create a new Token contract and return its address.
    return address(new OwnedToken(name));
  }
  function changeName(address tokenAddress, bytes32 name) {
    // We need an explicit type conversion because contract types are not part of the ABI.
    OwnedToken token = OwnedToken(tokenAddress);
    token.changeName(name);
  }
  function isTokenTransferOK(address currentOwner, address newOwner) returns (bool ok) {
    // Check some arbitrary condition.
    address tokenAddress = msg.sender;
    return (sha3(newOwner) & 0xff) == (bytes20(tokenAddress) & 0xff);
  }
}