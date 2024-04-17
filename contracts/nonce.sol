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

library Nonce {

	function session () internal view returns (uint256, uint256) {
		uint lcs;
		uint ts;
		uint ct;
		uint256 seed;
		uint256 salt;

		console.log("new session started (nonce)..");
		return Seed.session();
	}
}
