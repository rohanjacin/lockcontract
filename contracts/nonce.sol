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
import "./randomNumber.sol";

// Nonce structure (https://drive.google.com/file/d/1lza0qvFcVXlVRDdPPlYLRkMz2nAFCdVS/view?usp=sharing)
struct ChallengeNonce {
	bytes nonce0; //65
	bytes nonce1; //32
	bytes seed; //65
	bytes counter; //1
	bytes hmac; //32
}

library Nonce {

	// New exchange session
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

	// Solve for Lock's nonce
	function solve (uint256 _priv, ChallengeNonce calldata nonce)
					internal pure returns (bool, AffinePoint memory,
										   AffinePoint memory) {
		console.log("Solving Nonce..");
		return solveNonce(_priv, nonce);
	}

	// Extracts the public part of the nonce and calles the seed oracle
	function solveNonce (uint256 _priv, ChallengeNonce calldata nonce) 
						 internal pure returns (bool, AffinePoint memory,
						 						AffinePoint memory) {
		AffinePoint memory Pa;
		AffinePoint memory Pm;

		Pa = Point.createPointFromPublic(nonce.nonce0);
		console.log("Pa(x):", Pa.x);
		console.log("Pa(y):", Pa.y);
		Pm = Seed.retrieveSeed(_priv, Pa, nonce.seed);
		return (true, Pm, Pa);
	}

	// Generated the response challenge to be sent to the Lock
	function update (uint256 _priv, AffinePoint memory _pb,
					 AffinePoint memory _pa, AffinePoint memory _pm)
					 internal view returns (ChallengeNonce memory nonce) {

		nonce.nonce0 = Point.encodePointFromCipher(_pb);
		nonce.nonce1 = abi.encodePacked(RandomNumber.getNumber());
		nonce.seed = Seed.genSeed(_priv, _pb, _pa, _pm);
		nonce.counter = new bytes(1);
		nonce.hmac = abi.encodePacked(RandomNumber.getNumber());

		return nonce;
	}
}
