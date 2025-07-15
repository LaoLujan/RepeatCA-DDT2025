// SPDX-License-Identifier: GPL -3.0
pragma solidity >=0.7.0 <0.9.0;

contract LendAndBorrow {
    mapping (address => uint256) _balances; //mapping is the storage where I indicate that "address" is going to have the tokens stored
    mapping(address => mapping(address => uint256)) _allowed; // uint256 is the amount of tokens that we can store, tha ones the "address or users's have. 


//This is the basic information about the tokens
    string public name = "Lending Token";
    string public symbol ="LEND"; // this is not exactly mandatory but makes my token easy to identify, is like a nickname
    uint8 public decimals = 0; // no decimals allowed, wonly hole numbers 
    uint256 private_totalSuply = 100; //Total amount of tokens created

//    