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

	function session () internal view returns (uint256 _priv, string memory _type, uint256 _pb_x, uint256 _pb_y) {
/*		uint start;
		uint end;
		uint counter;
		uint counter_steps;
		uint time;
		uint256 nonce;
		uint256 lock_nonce;
*/
		console.log("new session started (handshake)..");
		(_priv, _pb_x, _pb_y) = Nonce.session();
		(_type, _pb_x, _pb_y) = sendRequest(_pb_x, _pb_y);
		return (_priv, _type, _pb_x, _pb_y);
	}

	function solve (uint256 _priv, ChallengeNonce calldata nonce)
					internal returns (bool, AffinePoint memory,
										   AffinePoint memory) {
		return Nonce.solve(_priv, nonce);
	}

	function sendRequest (uint256 _pb_x, uint256 _pb_y) internal view returns
						 (string memory _type, uint256, uint256) {
		console.log("Send Request (_pb_x):", _pb_x);
		console.log("Send Request (_pb_y):", _pb_y);
		_type = "Request";
		return (_type, _pb_x, _pb_y);
	}

	function update (uint256 _priv, AffinePoint memory _pb,
					 AffinePoint memory _pa, AffinePoint memory _pm)
					 internal view returns (ChallengeNonce memory nonce) {
		return Nonce.update(_priv, _pb, _pa, _pm);
	}
}
