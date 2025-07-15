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
     
//Total tokens after borrow
function totalSupply() public view returns(uint256){
       return _totalSuply -_balances[address(0)];   // This shows me how many tokens are stored. 
    }
     
     
     
     
     
     