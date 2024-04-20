const hre = require("hardhat");
const serverHandshake = require("../interface/server_handshake");
const BN = require("bn.js");

class LockNetwork extends serverHandshake {
	constructor() {
		super();
		this.samplelock = null;
		this.Lock = null;
		this.buildContractEventHandler();
		console.log("Lock net init.");
	}
}

LockNetwork.prototype.connect = async function () {

	this.Lock = await hre.ethers.getContractFactory('Lock');
	this.samplelock = await this.Lock.deploy('samplelock');
	await this.samplelock.waitForDeployment();
	console.log(`Deployed to ${this.samplelock.address}`);
	this.session();
}

LockNetwork.prototype.buildContractEventHandler = async function () {
	this.on('contract_event', function (event, data) {

		if (event == 'request') {
			console.log("Starting the handshake");
			this.request();
		}
		else if (event == 'challenge') {
			console.log("Solving the challenge");
			this.challenge(data);
		}
		else if (event == 'response') {
			console.log("Creating the challenge (response)");
			this.response();
		}				
	}.bind(this));
}

LockNetwork.prototype.request = async function () {
	await this.samplelock.session();

	let [type, pb_x, pb_y] = await this.samplelock.getSession();

	console.log("type:" + type + " pb_x:" + pb_x + " pb_y" + pb_y);

	if (type == 'Request') {
		//Send the request to the lock
		this.sendRequest(pb_x, pb_y);
	}
}

LockNetwork.prototype.challenge = async function (nonce) {

	let nonce0 = Uint8Array.from(nonce.data.slice(0, 65));
	let nonce1 = Uint8Array.from(nonce.data.slice(65, 97));
	let seed = Uint8Array.from(nonce.data.slice(97, 162));
	let counter = Uint8Array.from(nonce.data.slice(162, 163));
	let hmac = Uint8Array.from(nonce.data.slice(163, 195));

	const challenge = {nonce0, nonce1, seed, counter, hmac};
	console.log("nonce0:" + nonce0[0]);
	await this.samplelock.solve(challenge);

	let {matched} = await this.samplelock.getSolved();
	
	console.log("Matched:" + matched);

	this.validate(true);
}

LockNetwork.prototype.response = async function () {

	let nonce0;
	let nonce1;
	let seed;
	let counter;
	let hmac;

	console.log("Fetch response (challenge)");
	let response = await this.samplelock.update();

/*	console.log("response typeof:" + typeof(response));
	console.log("response[0] typeof:" + typeof(response[0]));
	console.log("response[1] typeof:" + typeof(response[1]));
	console.log("response[2] typeof:" + typeof(response[2]));
	console.log("response[3] typeof:" + typeof(response[3]));
	console.log("response[4] typeof:" + typeof(response[4]));
	console.log("Response[0]:" + response[0]);
*/
	console.log("Response is:" + JSON.stringify(response));
	nonce0 = new BN(response[0], 16).toBuffer(65);
	nonce1 = new BN(response[1], 16).toBuffer(32);
	seed = new BN(response[2], 16).toBuffer(65);
	counter = new BN(response[3], 16).toBuffer(1);
	hmac = new BN(response[4], 16).toBuffer(32);

	console.log("nonce0 is:" + nonce0);
	console.log("nonce1 is:" + nonce1);
	console.log("seed is:" + seed);
	console.log("counter is:" + counter);
	console.log("hmac is:" + hmac);

	console.log("nonce0(len):" + nonce0.length);
	console.log("nonce1(len):" + nonce1.length);
	console.log("seed(len):" + seed.length);
	console.log("counter(len):" + counter.length);
	console.log("hmac(len):" + hmac.length);

	let respnonce = Buffer.concat([nonce0, nonce1, seed, counter, hmac],
							 nonce0.length + nonce1.length + seed.length +
							 counter.length + hmac.length);
	console.log("Nonce is:" + JSON.stringify(respnonce));
	console.log("Nonce(len):" + respnonce.length);
	this.sendChallenge(respnonce);
}

var locknet = new LockNetwork();

locknet.connect().catch((error) => {
	console.error(error);
	process.exitCode = 1;	
});
