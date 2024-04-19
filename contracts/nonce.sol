//SPDX-License-Identifier: UNLICENSED
	
pragma solidity ^0.8.0;

/**
 ** @title Nonce library
 ** @dev Library generating and solving the nonces
 ** in the handshake protocol.
 ** This library accepts a challenge trys to solve it
 ** and generates a challenge in response.
 ** @author Bosco Jacinto
 */

import "hardhat/console.sol";
import "./seed.sol";
import "./point.sol";

struct ChallengeNonce {
	bytes nonce0; //65
	bytes nonce1; //32
	bytes seed; //65
	bytes counter; //1
}

library Nonce {

	function session () internal view returns (uint256, uint256, uint256) {
/*		uint lcs;
		uint ts;
		uint ct;
		uint256 seed;
		uint256 salt;
*/
		console.log("new session started (nonce)..");
		return Seed.session();
	}

	function solve (uint256 _priv, ChallengeNonce calldata nonce) internal view returns (bool) {
		console.log("Solving Nonce..");
		return solveNonce(_priv, nonce);
	}

	function solveNonce (uint256 _priv, ChallengeNonce calldata nonce) internal view returns (bool) {
		AffinePoint memory Pa;
		AffinePoint memory Pm;

		Pa = Point.createPointFromPublic(nonce.nonce0);
		console.log("Pa(x):", Pa.x);
		console.log("Pa(y):", Pa.y);
		Pm = Seed.retrieveSeed(_priv, Pa, nonce.seed);
		return true;
	}


}
