const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");

const deployment = buildModule("Deploy", (mod) => {
  const contract = mod.contract("DutchAuction", []);

  // mod.call(contract, "safeMint", [1], { value: ethers.parseEther("5") });

  return { contract };
});

module.exports = { deployment };
