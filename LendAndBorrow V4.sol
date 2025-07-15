// SPDX-License-Identifier: GPL -3.0
pragma solidity >=0.7.0 <0.9.0;

contract LendAndBorrow {
    mapping (address => uint256) _balances; //mapping is the storage where I indicate that "address" is going to have the tokens stored
    mapping(address => mapping(address => uint256)) _allowed; // uint256 is the amount of tokens that we can store, tha ones the "address or users's have. 


//This is the basic information about the tokens
    string public name = "Lending Token";
    string public symbol ="LEND"; // this is not exactly mandatory but makes my token easy to identify, is like a nickname
    uint8 public decimals = 0; // no decimals allowed, wonly hole numbers 
    uint256 _totalSuply = 100; //Total amount of tokens created

//Set the lender and borower roles
address public lender; // The lender will be the one who deploys the contract
address public borrower; // The borrower will be anyone who wants to borrow from it.

//Event declarations: These two events contains very importan and public information, it helps to search and find
//who made the transaction, who's revieving it, how much did they sent etc. This is part of ERC-20 standard, this is how the movements are track
    event Tranfer(address indexed _from, address indexed _to, uint256 _value);
    event Aproval(address indexed _owner, address indexed _spender, uint256 _value);

//Constructor is a function that creates the first contract. 
        constructor(address _borrower) { // This constructor contains the address of the borrower so it can be saved in the contact
            lender = msg.sender;  // message the sender, so this is the same person who deploys the contract
            borrower = _borrower; // Here i just saved the _borrower in the borrower variable.
            _balances[lender] = _totalSuply; // Here I am specifying that at this moment, the lender own all the tokens, 100 to be specific as we specify before. 
            emit transfer(address(0), lender, _totalSuply); // emit Transfer is the event that gives the 100 tokens to the lender, they where created from zero, the tokens were minted.
        }
     
//Total tokens that are currently available to use 
    function totalSupply() public view returns(uint256){
       return _totalSuply -_balances[address(0)];   // Here is the total supply of tokens minus the amount of tokens already used 
    }
//Getting the balance
    function balanceOf (address _owner) public view returns(uint256){ // Here I m storing in "balance Of" the amount of tokens each person or address owns
    return _balances[_owner]; // Returning the balance of a certain person
}

//View Approval allowence between owner and spender/ NOTE: this function does not cost gas, it is only for reading and set permission
function allowence (address _owner, address _spender) public view returns(uint256){ // Here I am returning the amount of tokens allowed for a certain user to spend from others
    return _allowed[_owner][_spender];   //The owner authorize the spender to use these tokens.
    }

//This the transfer function, but is not part of the lending process, this is the transfer from my own wallet
function transfer (address _to, uint256 _value) public returns(bool){ //The transer requires the Addres to who I'll send the money/tokens, and the amount
    require(_balances[msg.sender] >= _value, "Not enough tokens"); //Checking that the sender has enough tokens to perform the transaction.   
    _balances[msg.sender] -= _value; //This is the actual transaction, is substracting the value specified
    _balances[_to] += _value; //This is where the recipient gets the money, is added to the balance 
    emit Tranfer(msg.sender, _to, _value); // Emit is making public the strnsaction, in the real world there may be an app recieving this information to be updated in a wallet
    return true; // Confirm the trnsaction was a success.
}
//Now we aprove the usage of my tokens as a owner, here I approve this transaction. NOTE: This on cost gas, and is the one that use storage and emit the final value
function approve(address _spender, uint256 _value) public view returns (bool success){ // Aprove to the spender the value of ___ tokens, and this transaction is only for read, not to make changes
    _allowed[msg.sender][_spender] = _value; // The spender already was set with a maximun to spend, I think in the Function allowence
    emit Aproval(msg.sender, _spender, _value); // Emit the information to the wallets
    return true;
}


}
}
