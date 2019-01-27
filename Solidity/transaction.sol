pragma solidity ^0.4.0;

contract transaction{
    
    event SenderLogger(address);
    event ValueLogger(uint);
    
    address private owner;
    function transaction(){
        owner = msg.sender;
    }
    modifier isOwner(){
        require(owner == msg.sender);
        _;
    }
    modifier isValue(){
        assert( msg.value >= 1 ether);
        _;
    }
    function () payable isValue isOwner{ //fallback function
        SenderLogger(msg.sender);
        ValueLogger(msg.value);
    }
}
