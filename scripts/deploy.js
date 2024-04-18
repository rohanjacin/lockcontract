const hre = require("hardhat");
const serverHandshake = require("../interface/server_handshake");


class LockNetwork extends serverHandshake {
	constructor() {
		super();
		this.samplelock = null;
		this.Lock = null;
		this.buildEventHandler();
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

LockNetwork.prototype.buildEventHandler = async function () {
	this.on('contract_event', function (event) {

		console.log("contract_event");
		if (event == 'request') {
			console.log("Starting the handshake");
			this.request();
		}
	}.bind(this));
}

LockNetwork.prototype.request = async function () {
	let [type, pb_x, pb_y] = (await this.samplelock.session());

	if (type == 'Request') {
		//Send the reuest to the lock
		this.sendRequest(pb_x, pb_y);
	}
}

var locknet = new LockNetwork();

locknet.connect().catch((error) => {
	console.error(error);
	process.exitCode = 1;	
});
