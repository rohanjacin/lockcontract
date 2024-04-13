//SPDX-License-Identifier: UNLICENSED
	
pragma solidity ^0.8.0;

/**
 ** @title Handshake library
 ** @dev Library handling the handshake frames.
 ** This library starts a new handshake session
 ** @author Bosco Jacinto
 */

import "hardhat/console.sol";
import "./nonce.sol";

library Handshake {

	function session () internal view returns (uint256) {
		uint start;
		uint end;
		uint counter;
		uint counter_steps;
		uint time;
		uint256 nonce;
		uint256 lock_nonce;

		console.log("new session started (handshake)..");
		Nonce.session();
		return 1;//nonce
	}
}
