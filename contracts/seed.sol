//SPDX-License-Identifier: UNLICENSED
	
pragma solidity ^0.8.0;

/**
 ** @title Seed library
 ** @dev Library generating the seed and salt as 
 ** part of the nonce in the handshake protocol.
 ** This library creates a cryptographic secret
 ** using kobiltz encoding over and ellptic curve
 ** It also solves the challenge and extracts the
 ** secret coming from the lock.
 ** @author Bosco Jacinto
 */

import "hardhat/console.sol";
import "./randomNumber.sol";
import "./EllipticCurve.sol";

library Seed {

	function session () internal view returns (uint256) {
		uint lcs;
		uint ts;
		uint ct;
		uint256 seed;
		uint256 salt;
		uint256 pub;
		uint256 priv;

		console.log("new session started (seed)..");
		(pub, priv) = genKeyPair();
		console.log("pub:", pub);
		console.log("priv:", priv);
		return 1;
	}

	function genKeyPair () internal view returns (uint256, uint256) {
		uint256 GX = 0x79BE667EF9DCBBAC55A06295CE870B07029BFCDB2DCE28D959F2815B16F81798;
		uint256 GY = 0x483ADA7726A3C4655DA4FBFC0E1108A8FD17B448A68554199C47D08FFB10D4B8;
		uint256 AA = 0;
		uint256 BB = 7;
		uint256 PP = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFFFFFC2F;
		uint256 qx;
		uint256 qy;

		uint256 k = RandomNumber.getNumber();
		//console.log("Private key:", k);				

	    (qx, qy) = EllipticCurve.ecMul(
	      k, GX, GY, AA, PP
	      );
	    //console.log("Public key:", qx);
	    //console.log("qy:", qy);
	    return (k, qx);
	}
}
