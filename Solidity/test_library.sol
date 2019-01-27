pragma solidity ^0.4.0;

import "browser/library.sol";

contract testLibrary {
    using intExtended for uint;
    
    function test_increment(uint _base) returns(uint){
        return _base.increment();
    }
    
    function test_decrement(uint _base) returns(uint){
        return _base.decrement();
    }
    
    function test_increment_by_value(uint _base,uint _value) returns(uint){
        return _base.incrementByValue(_value);
    }
    
    function test_decrement_by_value(uint _base,uint _value) returns(uint){
        return _base.decrementByValue(_value);
    }
}
