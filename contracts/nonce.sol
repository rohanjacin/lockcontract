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
	bytes hmac; //32
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

	function solve (uint256 _priv, ChallengeNonce calldata nonce)
					internal returns (bool, AffinePoint memory,
										   AffinePoint memory) {
		console.log("Solving Nonce..");
		return solveNonce(_priv, nonce);
	}

	function solveNonce (uint256 _priv, ChallengeNonce calldata nonce) 
						 internal returns (bool, AffinePoint memory,
						 						AffinePoint memory) {
		AffinePoint memory Pa;
		AffinePoint memory Pm;

		Pa = Point.createPointFromPublic(nonce.nonce0);
		console.log("Pa(x):", Pa.x);
		console.log("Pa(y):", Pa.y);
		Pm = Seed.retrieveSeed(_priv, Pa, nonce.seed);
		return (true, Pm, Pa);
	}

	function update (uint256 _priv, AffinePoint memory _pb,
					 AffinePoint memory _pa, AffinePoint memory _pm)
					 internal view returns (ChallengeNonce memory nonce) {
		//bytes memory n = new bytes(32);
		//bytes memory ct = new bytes(1);
		//bytes memory n = new bytes(32);

		nonce.nonce0 = Point.encodePointFromCipher(_pb);
		//nonce.nonce1 = keccak256(abi.encodePacked(h.concat(ct, lcs)));
		nonce.nonce1 = new bytes(32);
		nonce.seed = Seed.genSeed(_priv, _pb, _pa, _pm);
		nonce.counter = new bytes(1);
		nonce.hmac = new bytes(32);

		console.log("nonce.nonce0(len):", nonce.nonce0.length);
		console.log("nonce.nonce1(len):", nonce.nonce1.length);
		console.log("nonce.seed(len):", nonce.seed.length);
		console.log("nonce.counter(len):", nonce.counter.length);
		console.log("nonce.hmac(len):", nonce.hmac.length);

		return nonce;
	}
}
