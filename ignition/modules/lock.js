const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");
var BN = require('bn.js');

module.export = buildModule("SampleLock", (m) => {
	const samplelock = m.contract("Lock");

	let lock_priv = new BN('a3a', 16);
	lock_priv = lock_priv.toNumber();
	//let lock_priv = "0x111222";

	m.call(samplelock, "genPub", lock_priv);

	return { samplelock };
})