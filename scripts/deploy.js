const hre = require("hardhat");
var BN = require('bn.js');

async function main() {
	const Lock = await hre.ethers.getContractFactory('Lock');
	let lock_priv = new BN('a3a', 16);
	const samplelock = await Lock.deploy('samplelock');

	console.log("samplelock:" + JSON.stringify(samplelock));
	//await samplelock.deployed();

	console.log(`Deployed to ${samplelock.address}`);
}

main().catch((error) =>{
	console.error(error);
	process.exitCode = 1;
});