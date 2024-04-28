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

import "./handshake.sol";
import "hardhat/console.sol";

contract Lock {

  string name;
  struct Session {
    // Owner's private key
    uint256 priv;
    // Owner's public key
    AffinePoint pb;
    AffinePoint pa;
    // Lock's secret point
    AffinePoint pm;
    // Frame type
    string ftype;
    // Lock's extracted secret match w/ expected secret status
    bool matched;
  }

  mapping (address => Session) sessions;

  constructor (string memory _name) {
    name = _name;
    console.log("name:", name);
  } 

  // New handshake session
  function session () public returns (string memory _type, uint256 _Pb_x, uint256 _Pb_y) {
    uint256 _priv;
    Session memory s;

    console.log("new session started (server):", msg.sender);
    (_priv, _type, _Pb_x, _Pb_y) = Handshake.session();

    s.priv = _priv;
    s.pb.x = _Pb_x;
    s.pb.y = _Pb_y;
    s.ftype = _type;
    sessions[msg.sender] = s;

    // Returns the initial exchange data (the owner's public key)
    return (_type, _Pb_x, _Pb_y);
  }

  function getSession() public view returns (string memory _type, uint256 _Pb_x, uint256 _Pb_y) {
    
    Session memory sp = sessions[msg.sender];
    return (sp.ftype, sp.pb.x, sp.pb.y);
  }

  // Solves for the nonce sent from the lock and returns 
  // true if Lock's extracted secret equals expected secret
  function solve (ChallengeNonce calldata nonce)
                  public returns (bool) {
    Session memory sp = sessions[msg.sender];

    console.log("challege to solve (server):", msg.sender);

    (sp.matched, sp.pm, sp.pa) = Handshake.solve(sp.priv, nonce);
    sessions[msg.sender] = sp;
    console.log("s.matched:", sp.matched);

    return sp.matched;
  }

  function getSolved () public view returns (bool matched) {
    
    Session memory s = sessions[msg.sender];
    console.log("getSolved:", msg.sender);
    console.log("s.matched:", s.matched);
    return (s.matched);
  }

  // Generated Owner's nonce to be sent in return to Lock's challenge
  function update () public view returns (ChallengeNonce memory nonce) {

    console.log("Update", msg.sender);    
    Session memory s = sessions[msg.sender];

    return Handshake.update(s.priv, s.pb, s.pa, s.pm);
  }
}