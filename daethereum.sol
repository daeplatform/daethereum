pragma solidity 0.4.24;



// ---------- ---------- ---------- ---------- ----------
// Token Name: Daethereum
// Token Symbol: DTHR
// Total Supply: 100,000,000
// Decimals: 8
// Token Type: ERC20
// (c) Dae Platform.
// ---------- ---------- ---------- ---------- ----------



import './SafeMath.sol';
import './token.sol';
import './ERC20TokenInterface.sol';
import './ERC20Token.sol';
import './Daethereum.sol';



library SafeMath {
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        assert(b <= a);
        return a - b;
    }
    function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
        c = a + b;
        assert(c >= a);
        return c;
    }
}

contract token {
    function balanceOf(address _owner) public constant returns (uint256 balance);
    function transfer(address _to, uint256 _value) public returns (bool success);
}

contract ERC20TokenInterface {
    function balanceOf(address _owner) public view returns (uint256 balance);
    function transfer(address _to, uint256 _value) public returns (bool success);
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
    function approve(address _spender, uint256 _value) public returns (bool success);
    function allowance(address _owner, address _spender) public view returns (uint256 remaining);
}

contract ERC20Token is ERC20TokenInterface {
    using SafeMath for uint256;
    uint256 public totalSupply;
    mapping (address => uint256) balances;
    mapping (address => mapping (address => uint256)) allowed;
    mapping (address => bool) frozen;
    function balanceOf(address _owner) public constant returns (uint256 value) {
        return balances[_owner];
    }
    function transfer(address _to, uint256 _value) public returns (bool success) {
        require(_to != address(0)); //If you dont want that people destroy token
        require(frozen[msg.sender]==false);
        balances[msg.sender] = balances[msg.sender].sub(_value);
        balances[_to] = balances[_to].add(_value);
        emit Transfer(msg.sender, _to, _value);
        return true;
    }
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        require(_to != address(0)); //If you dont want that people destroy token
        require(frozen[_from]==false);
        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
        balances[_from] = balances[_from].sub(_value);
        balances[_to] = balances[_to].add(_value);
        emit Transfer(_from, _to, _value);
        return true;
    }
    function approve(address _spender, uint256 _value) public returns (bool success) {
        require((_value == 0) || (allowed[msg.sender][_spender] == 0));
        allowed[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }
    function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
        return allowed[_owner][_spender];
    }
    function burnToken(uint256 _burnedAmount) public {
        balances[msg.sender] = SafeMath.sub(balances[msg.sender], _burnedAmount);
        totalSupply = SafeMath.sub(totalSupply, _burnedAmount);
        emit Burned(msg.sender, _burnedAmount);
    }
    function setFrozen(address _target,bool _flag) public {
        frozen[_target]=_flag;
        emit FrozenStatus(_target,_flag);
    }
    function batch(address[] _target,uint256[] _amount) public {
        require(_target.length == _amount.length);
        uint256 size = _target.length;
        for (uint i=0; i<size; i++) {
            transfer(_target[i],_amount[i]);
        }
    }
    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
    event Burned(address indexed _target, uint256 _value);
    event FrozenStatus(address _target,bool _flag);
}

contract Daethereum is ERC20Token {
    string public name = 'Daethereum';
    uint8 public decimals = 8;
    string public symbol = 'DTHR';
    string public version = '0.1';
    constructor() public {
        totalSupply = 100000000 * 10 ** uint256(decimals);
        balances[msg.sender] = totalSupply;
        emit Transfer(0, msg.sender, totalSupply);
    }
    function externalTokensRecovery(token _address) public {
        uint256 remainder = _address.balanceOf(this);
        _address.transfer(msg.sender,remainder);
    }
    function() public {
        revert();
    }
}
