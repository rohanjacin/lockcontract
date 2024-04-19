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
import "./EllipticCurve.sol";
import "./randomNumber.sol";
import "./point.sol";

library Seed {

	function session () internal view returns (uint256, uint256, uint256) {
/*		uint lcs;
		uint ts;
		uint ct;
		uint256 seed;
		uint256 salt;
*/		uint256 pub_x;
		uint256 pub_y;	
		uint256 priv;

		console.log("new session started (seed)..");
		(priv, pub_x, pub_y) = genSeed();
		console.log("priv:", priv);
		console.log("pub_x:", pub_x);
		console.log("pub_y:", pub_y);
		return (priv, pub_x, pub_y);
	}

	function genSeed () internal view returns (uint256, uint256, uint256) {

		uint256 k = RandomNumber.getNumber();
		console.log("Private key:", k);				

	    return Point.genKeyPair(k);
	}

	function retrieveSeed (uint256 _priv, AffinePoint memory _Pa, bytes calldata _seed) internal view returns (AffinePoint memory Pm) {
		AffinePoint memory CipherPt_2;
		AffinePoint memory SharedPt;

		console.log("retrieveSeed:");
		CipherPt_2 = Point.createPointFromPublic(_seed);
		console.log("CipherPt_2(x):", CipherPt_2.x);
		console.log("CipherPt_2(y):", CipherPt_2.y);

		(SharedPt.x, SharedPt.y) = EllipticCurve.ecMul(_priv, _Pa.x, _Pa.y,
							Point.AA, Point.PP);

		console.log("SharedPt(x):", SharedPt.x);
		console.log("SharedPt(y):", SharedPt.y);

		if (true == EllipticCurve.isOnCurve(SharedPt.x, SharedPt.y,
								Point.AA, Point.BB, Point.PP)) {
		}

		(SharedPt.x, SharedPt.y) = EllipticCurve.ecInv(SharedPt.x, SharedPt.y, Point.PP);

		(Pm.x, Pm.y) = EllipticCurve.ecAdd(CipherPt_2.x, CipherPt_2.y,
							SharedPt.x, SharedPt.y,
							Point.AA, Point.PP);

		console.log("Pm(x):", Pm.x);
		console.log("Pm(y):", Pm.y);

		if (true == EllipticCurve.isOnCurve(SharedPt.x, SharedPt.y,
								Point.AA, Point.BB, Point.PP)) {
		}


	}
}
