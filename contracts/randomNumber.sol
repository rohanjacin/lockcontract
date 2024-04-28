//SPDX-License-Identifier: UNLICENSED
	
pragma solidity ^0.8.0;

/**
 ** @title Temporary Random Number Generator library
 ** @dev Library generating the random number taking 
 ** arguments msg.sender, block.timestamp and seed.
 ** @author Bosco Jacinto
 */

import "hardhat/console.sol";

library RandomNumber {

	// Generates pesudo random number
	function getNumber () internal view returns (uint) {
		uint randNo = 0;
		randNo = uint (keccak256(abi.encodePacked(msg.sender, block.timestamp, randNo)));
		return randNo;
	}
}