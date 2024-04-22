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
  struct Session {
    uint256 priv;
    AffinePoint pb;
    AffinePoint pa;
    AffinePoint pm;
    string ftype;
    bool matched;
  }

  mapping (address => Session) sessions;

  constructor (string memory _name) {
    name = _name;
    console.log("name:", name);
  } 

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

    return (_type, _Pb_x, _Pb_y);
  }

  function getSession() public view returns (string memory _type, uint256 _Pb_x, uint256 _Pb_y) {
    
    Session memory sp = sessions[msg.sender];
    return (sp.ftype, sp.pb.x, sp.pb.y);
  }

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

  function update () public view returns (ChallengeNonce memory nonce) {

    console.log("Update", msg.sender);    
    Session memory s = sessions[msg.sender];

    return Handshake.update(s.priv, s.pb, s.pa, s.pm);
  }
}