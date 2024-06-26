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

	// New exchange session
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
		(priv, pub_x, pub_y) = genRPV();
		console.log("priv:", priv);
		console.log("pub_x:", pub_x);
		console.log("pub_y:", pub_y);
		return (priv, pub_x, pub_y);
	}

	// Generates a random epherium pub/priv pair
	function genRPV () internal view returns (uint256, uint256, uint256) {

		uint256 k = RandomNumber.getNumber();
		console.log("Private key:", k);				

	    return Point.genKeyPair(k);
	}

	// Retrieves the Lock's secret (Pm) from the seed in the challenge nonce
	function retrieveSeed (uint256 _priv, AffinePoint memory _Pa, bytes calldata _seed) internal pure returns (AffinePoint memory Pm) {
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

		return Pm;
	}

	// Generates a seed with the Lock's secret (Pm received and extracted from the challenge)
	function genSeed (uint256 _priv, AffinePoint memory _Pb,
					  AffinePoint memory _Pa, AffinePoint memory _Pm)
					  internal pure returns (bytes memory) {
		AffinePoint memory CipherPt_1;
		AffinePoint memory CipherPt_2;

		CipherPt_1 = _Pb;
		CipherPt_2 = _Pa;

		console.log("genSeed..");
		console.log("_Pm(x):", _Pm.x);
		console.log("_Pm(y):", _Pm.y);

		(CipherPt_2.x, CipherPt_2.y) = EllipticCurve.ecMul(_priv, CipherPt_2.x, CipherPt_2.y,
							Point.AA, Point.PP);

		(CipherPt_2.x, CipherPt_2.y) = EllipticCurve.ecAdd(CipherPt_2.x, CipherPt_2.y,
							_Pm.x, _Pm.y, Point.AA, Point.PP);
	
		console.log("CipherPt_2(x):", CipherPt_2.x);
		console.log("CipherPt_2(y):", CipherPt_2.y);

		if (true == EllipticCurve.isOnCurve(CipherPt_2.x, CipherPt_2.y,
								Point.AA, Point.BB, Point.PP)) {
			console.log("CipherPt2 is on the curve");
		}

		return Point.encodePointFromCipher(CipherPt_2);
	}
}
