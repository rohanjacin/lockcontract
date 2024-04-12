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
import "./EllipticCurve.sol";
import "hardhat/console.sol";

contract Lock {

  string name;
  uint256 public constant GX = 0x79BE667EF9DCBBAC55A06295CE870B07029BFCDB2DCE28D959F2815B16F81798;
  uint256 public constant GY = 0x483ADA7726A3C4655DA4FBFC0E1108A8FD17B448A68554199C47D08FFB10D4B8;
  uint256 public constant AA = 0;
  uint256 public constant BB = 7;
  uint256 public constant PP = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFFFFFC2F;

  constructor (string memory _name) {
    name = _name;
    console.log("name:", name);
  } 

  function genPub(uint256 privKey) public pure returns(uint256 qx, uint256 qy) {
    (qx, qy) = EllipticCurve.ecMul(
      privKey, GX, GY, AA, PP
      );
  }
}