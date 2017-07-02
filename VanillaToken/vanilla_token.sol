pragma solidity ^0.4.11;

// Contract must implement the ERC20 Token Standard Interface
contract ERC20Interface {
    function totalSupply() constant returns (uint256 totalSupply);
    function balanceOf(address _owner) constant returns (uint256 balance);
    function transfer(address _to, uint256 _value) returns (bool success);
    function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
    function approve(address _spender, uint256 _value) returns (bool success);
    function allowance(address _owner, address _spender) constant returns (uint256 remaining);

    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
}

contract VanillaToken is ERC20Interface{

    address owner;
    string public constant name = "Vanilla Token";
    string public constant symbol = "VT";
    uint8 public constant decimals = 8;
    uint256 public constant _totalSupply = 2100000000000000;

    mapping(address => uint) public balances;
    mapping(address => mapping (address => uint256)) allowed;

    function VanillaToken(){
        owner = msg.sender;
        balances[msg.sender] = _totalSupply;
    }

    function totalSupply() constant returns (uint256 totalSupply){
        return _totalSupply;
    }

    function transfer(address _to, uint256 _value) returns (bool success){
        if(_to == 0x0) throw;
        if(_value < 0 || _value > _totalSupply) throw;
        if(balances[msg.sender] < _value) throw;
        if(balances[_to] + _value < balances[_to]) throw;
        balances[msg.sender] -= _value;
        balances[_to] += _value;
        Transfer(msg.sender, _to, _value);
        return true;
    }

    function balanceOf(address _owner) constant returns (uint256 balance){
        return balances[_owner];
    }

    function transferFrom(address _from, address _to, uint256 _amount) returns (bool success) {
        if(balances[_from] >= _amount
             && allowed[_from][msg.sender] >= _amount
             && _amount > 0
             && balances[_to] + _amount > balances[_to]) {
             balances[_from] -= _amount;
             allowed[_from][msg.sender] -= _amount;
             balances[_to] += _amount;
             Transfer(_from, _to, _amount);
             return true;
         } else {
             return false;
         }
     }

    function approve(address _spender, uint256 _amount) returns (bool success) {
        allowed[msg.sender][_spender] = _amount;
        Approval(msg.sender, _spender, _amount);
        return true;
    }

    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
        return allowed[_owner][_spender];
    }

    function release(){
        if(msg.sender != owner) throw;
        selfdestruct(owner);
    }

    // fallback function
    function() payable {

    }

}
