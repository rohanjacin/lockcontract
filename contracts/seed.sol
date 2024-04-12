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

library Seed {

	function session () internal pure returns (uint256) {
		uint lcs;
		uint ts;
		uint ct;
		uint256 seed;
		uint256 salt;

		console.log("new session started (seed)..");
		return 1;
	}
}
