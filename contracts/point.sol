//SPDX-License-Identifier: UNLICENSED
	
pragma solidity ^0.8.0;

/**
 ** @title Public key point encoding and decoding library
 ** @dev Library uses uncompresses hybrid-odd, hybrid even
 ** technique to ecode x and y along with sign
 ** @author Bosco Jacinto
 */

import "./EllipticCurve.sol";
import "hardhat/console.sol";

struct AffinePoint {
	uint256 x;
	uint256 y;
}

library Point {

	uint256 constant GX = 0x79BE667EF9DCBBAC55A06295CE870B07029BFCDB2DCE28D959F2815B16F81798;
	uint256 constant GY = 0x483ADA7726A3C4655DA4FBFC0E1108A8FD17B448A68554199C47D08FFB10D4B8;
	uint256 constant AA = 0;
	uint256 constant BB = 7;
	uint256 constant PP = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFFFFFC2F;
	uint8 constant len = 32;

	function decode (bytes calldata key) internal pure returns (bytes32 _x, bytes32 _y) {
		
		// uncompressed, hybrid-odd, hybrid-even
		if ((key[0] == 0x04 || key[0] == 0x06 || key[0] == 0x07) &&
		      key.length - 1 == 2 * len) {

			if (key[0] == 0x06) {
				assert(uint8(key[key.length - 1]) % 2 == 0);
			}
			else if (key[0] == 0x07) {
				assert(uint8(key[key.length - 1]) % 2 == 1);
			}

			_x = bytes32(key[1 : 1+len]);
			_y = bytes32(key[1+len : 1+2*len]);

			return (_x, _y);
		}
	}

	function genKeyPair (uint256 k) internal view returns (uint256, uint256, uint256) {
		uint256 qx;
		uint256 qy;

	    k = EllipticCurve.expMod(k, 1, PP);
		console.log("Private key(umod(n)):", k);				
	    
	    (qx, qy) = EllipticCurve.ecMul(
	      k, GX, GY, AA, PP
	      );
	    console.log("qx:", qx);
	    console.log("qy:", qy);
	    return (k, qx, qy);
	}

	function createPointFromPublic (bytes calldata key) internal view returns (AffinePoint memory _P) {		
		bytes32 _xx;
		bytes32 _yy;
			
		(_xx, _yy) = decode(key);

		if (true == EllipticCurve.isOnCurve(uint(_xx), uint(_yy), AA, BB, PP)) {
			_P.x = uint256(_xx);
			_P.y = uint256(_yy);
			return _P;
		}
	}
}