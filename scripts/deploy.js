const hre = require("hardhat");
const serverHandshake = require("../interface/server_handshake");


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

	const challenge = {nonce0, nonce1, seed, counter};
	console.log("nonce0:" + nonce0[0]);
	await this.samplelock.solve(challenge);

	//if (type == 'Response') {
		//Send the response to the lock
		//this.sendRequest(pb_x, pb_y);
	//}
}

var locknet = new LockNetwork();

locknet.connect().catch((error) => {
	console.error(error);
	process.exitCode = 1;	
});
