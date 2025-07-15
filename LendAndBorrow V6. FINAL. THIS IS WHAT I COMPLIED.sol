// SPDX-License-Identifier: GPL -3.0
pragma solidity >=0.7.0 <0.9.0;

contract LendAndBorrow {
    mapping (address => uint256) _balances; //mapping is the storage where I indicate that "address" is going to have the tokens stored
    mapping(address => mapping(address => uint256)) _allowed; // uint256 is the amount of tokens that we can store, tha ones the "address or users's have. 


//This is the basic information about the tokens
    string public name = "Lending Token";
    string public symbol ="LEND"; // this is not exactly mandatory but makes my token easy to identify, is like a nickname
    uint8 public decimals = 0; // no decimals allowed, wonly hole numbers 
    uint256 _totalSupply = 100; //Total amount of tokens created

//Set the lender and borower roles
address public lender; // The lender will be the one who deploys the contract
address public borrower; // The borrower will be anyone who wants to borrow from it.

//Event declarations: These two events contains very importan and public information, it helps to search and find
//who made the transaction, who's revieving it, how much did they sent etc. This is part of ERC-20 standard, this is how the movements are track
    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);

//Constructor is a function that creates the first contract. 
        constructor(address _borrower) { // This constructor contains the address of the borrower so it can be saved in the contact
            lender = msg.sender;  // message the sender, so this is the same person who deploys the contract
            borrower = _borrower; // Here i just saved the _borrower in the borrower variable.
            _balances[lender] = _totalSupply; // Here I am specifying that at this moment, the lender own all the tokens, 100 to be specific as we specify before. 
            emit Transfer(address(0), lender, _totalSupply); // emit Transfer is the event that gives the 100 tokens to the lender, they where created from zero, the tokens were minted.
        }
     
//Total tokens that are currently available to use 
    function totalSupply() public view returns(uint256){
       return _totalSupply -_balances[address(0)];   // Here is the total supply of tokens minus the amount of tokens already used 
    }
//Getting the balance
    function balanceOf (address _owner) public view returns(uint256){ // Here I m storing in "balance Of" the balance of the owner's tokens
    return _balances[_owner]; 
    }
//View Approval allowence between owner and spender/ NOTE: this function does not cost gas, it is only for reading and set permission
function allowance (address _owner, address _spender) public view returns(uint256){ // Here I am returning the amount of tokens allowed for a certain user to spend from others
    return _allowed[_owner][_spender];   //The owner authorize the spender to use these tokens.
    }

//This the transfer function, but is not part of the lending process, this is the transfer from my own wallet, is case I was the owner
function transfer (address _to, uint256 _value) public returns(bool){ //The transer requires the Addres to who I'll send the money/tokens, and the amount
    require(_balances[msg.sender] >= _value, "Not enough tokens"); //Checking that the owner has enough tokens to perform the transaction.   
    _balances[msg.sender] -= _value; //This is the actual transaction, is substracting the value specified
    _balances[_to] += _value; //This is where the recipient (spender) gets the money, is added to the balance
    emit Transfer(msg.sender, _to, _value); // Emit is making public the strnsaction, in the real world there may be an app recieving this information to be updated in a wallet
    return true; // Confirm the trnsaction was a success.
}
//Now we aprove the usage of my tokens as a owner, here I approve this transaction. NOTE: This do cost gas, and is the one that use storage and emit the final value
function approve(address _spender, uint256 _value) public returns (bool success){ // Aprove to the spender the value of ___ tokens, and this transaction is only for read, not to make changes
    _allowed[msg.sender][_spender] = _value; // The spender already was set with a maximun to spend, I think in the Function allowence
    emit Approval(msg.sender, _spender, _value); // Emit the information to the wallets/apps
    return true;
}

//Here goes the transaction, the transfer of tokens, and this will olly happen if is allowed, by the function we already wrote. NOTE; This is still not the lending part :O
//This transaction is between the Owner and the spender only
    function transferFrom(address _from, address _to, uint256 _value)public returns (bool success){
    require(_balances[_from] >= _value, "Not enough balance");


    _balances[_from] -= _value; // This takes the tokens from the owner
    _balances[_to] += _value; //And deposit then in the recipient, which is the spender
    _allowed[_from][msg.sender] -= _value; // This reduces the tokens sent from the owners account

    emit Transfer(_from, _to, _value); // Again emit is the transmition to the apps or wallets, so they can record this transaction
    return true;
}
//Here finally THE LENDING FUNCTION!: lender send the tokens to the borrower
function lendToken(uint256 _amount) public returns (bool){
    require(msg.sender == lender, "Only lender can lend"); //This is requires that ONLY the lender can use this function
    

    if (_balances[lender] >= _amount) { // The actual transfer. This deduct the tokens from the lender account
    _balances[lender] = _balances[lender] - _amount; // This deduct the tokens from the lender account
    _balances[borrower] += _amount;// This one recieve the tokens in the borrower acound
    emit Transfer(lender, borrower, _amount);
    return true;
    } else {
        revert("Not enough balance");
    }
}}