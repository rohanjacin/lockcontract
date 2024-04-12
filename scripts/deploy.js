const hre = require("hardhat");

async function main() {
	const Lock = await hre.ethers.getContractFactory('Lock');
	const lock_priv = 42n;

	const samplelock = await Lock.deploy('samplelock', lock_priv);

	console.log("samplelock:" + JSON.stringify(samplelock));
	await samplelock.waitForDeployment();

	samplelock.session();
	console.log(`Deployed to ${samplelock.address}`);
}

main().catch((error) =>{
	console.error(error);
	process.exitCode = 1;
});