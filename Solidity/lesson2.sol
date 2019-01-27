pragma solidity ^0.4.0;

interface Regulator{
    function checkValue(uint) returns (bool);
    function loan(uint) returns (bool);
}

contract Bank is Regulator{
    uint private value;
    address private owner;
    
    function Bank(uint amount){
        value = amount;
        owner = msg.sender;
    }
    
    modifier isOwner{
        require(owner == msg.sender);
        _;
    }
    
    function withdraw(uint amount) isOwner{
        if(checkValue(amount)){
            value -= amount;
        }
    }
    
    function deposit(uint amount) isOwner{
        value += amount;
    }
    
    function balance() returns (uint){
        return value;
    } 
    
    function checkValue(uint amount) returns (bool){
        return value >= amount;
    }
    
    function loan(uint amount) returns(bool){
        return value>0;
    }
}

contract lesson2 is Bank(10) {
    string private name;
    uint private age;
    
    function setName(string newName){
        name = newName;
    }
    
    function getName() returns (string){
        return name;
    }
    
    function setAge(uint newAge){
        age = newAge;
    }
    
    function getAge() returns (uint){
        return age;
    }
}

contract ErrorHandling{
    function test_require(){
        require(2==1);//boolean
    }
    
    function test_assert(){
        assert(2==1);//boolean
    }

    function test_revert(){
        revert();
    }
    
    function test_throw(){
        throw;
    }

}
