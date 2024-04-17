//SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;
/**
 * The Lock contract does the following
 * 1. Authenticate the Lock and the Guest
 *    a. Accepts the challenge from the physical lock (thru the Guest's phone)
 *    b. Solves the challenge and extracts the lock secret (Pm)
 *    c. Generates the response challenge by encoding the same lock secret
 *    d. Sends the reponse challenge to the phycical lock (thru the Guest's phone)
 */

//elliptic-curve-solidity/contracts/
import "./handshake.sol";
import "hardhat/console.sol";

contract Lock {

  string name;

  constructor (string memory _name) {
    name = _name;
    console.log("name:", name);
  } 

  function session () public view returns (string memory, uint256, uint256){
    console.log("new session started (server)..");
    return Handshake.sendRequest();
  }
}