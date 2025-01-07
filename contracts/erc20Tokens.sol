pragma solidity >=0.8.10 <0.8.21;

import "./erc20interface.sol";

contract ERC20Token is ERC20Interface {
    uint256 constant private MAX_UINT256 = type(uint256).max;
    mapping(address => uint256) public balances;
    mapping(address => mapping(address => uint256)) public allowed;

    string public name;                 // Descriptive name of the token
    uint8 public decimals;              // Decimal places
    string public symbol;               // Token symbol
    uint256 private _totSupply;         // Internal storage for total supply

    // Constructor to initialize the token's properties
    constructor(
        uint256 _initialAmount,
        string memory _tokenName,
        uint8 _decimalUnits,
        string memory _tokenSymbol
    ) {
        balances[msg.sender] = _initialAmount; // Assign all tokens to contract creator
        _totSupply = _initialAmount;          // Set total supply
        name = _tokenName;                    // Set token name
        decimals = _decimalUnits;             // Set number of decimals
        symbol = _tokenSymbol;                // Set token symbol
    }

    // Implement the totalSupply function from the interface
    function totalSupply() public view override returns (uint256) {
        return _totSupply;
    }

    // Transfer tokens from the caller's address to another address
    function transfer(address _to, uint256 _value) public override returns (bool success) {
        require(balances[msg.sender] >= _value, "Insufficient balance");
        balances[msg.sender] -= _value;
        balances[_to] += _value;
        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    // Transfer tokens on behalf of another address
    function transferFrom(address _from, address _to, uint256 _value) public override returns (bool success) {
        uint256 currentAllowance = allowed[_from][msg.sender];
        require(balances[_from] >= _value, "Insufficient balance");
        require(currentAllowance >= _value, "Transfer exceeds allowance");
        balances[_from] -= _value;
        balances[_to] += _value;
        if (currentAllowance != MAX_UINT256) {
            allowed[_from][msg.sender] -= _value;
        }
        emit Transfer(_from, _to, _value);
        return true;
    }

    // Get the token balance of a specific address
    function balanceOf(address _owner) public view override returns (uint256 balance) {
        return balances[_owner];
    }

    // Approve an address to spend a specific amount of tokens on behalf of the caller
    function approve(address _spender, uint256 _value) public override returns (bool success) {
        allowed[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    // Return the remaining allowance for a spender
    function allowance(address _owner, address _spender) public view override returns (uint256 remaining) {
        return allowed[_owner][_spender];
    }
}
f