const hre = require("hardhat");
const serverHandshake = require("../interface/server_handshake");


class LockNetwork extends serverHandshake {
	constructor() {
		super();
		this.samplelock = null;
		this.buildEventHandler();
		console.log("Lock net init.");
	}
}

LockNetwork.prototype.connect = async function () {
	const Lock = await hre.ethers.getContractFactory('Lock');

	this.samplelock = await Lock.deploy('samplelock');

	console.log("samplelock:" + JSON.stringify(this.samplelock));
	await this.samplelock.waitForDeployment();
	console.log(`Deployed to ${this.samplelock.address}`);
	this.session();
}

LockNetwork.prototype.buildEventHandler = async function () {
	this.on('contract_event', function (event) {

		console.log("contract_event");
		if (event == 'request') {
			console.log("Starting the handshake");
			let [type, pb_x, pb_y] = (await this.samplelock.session());		
		}
	}.bind(this));
}

var locknet = new LockNetwork();

locknet.connect().catch((error) => {
	console.error(error);
	process.exitCode = 1;	
});
