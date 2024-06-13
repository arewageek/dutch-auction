const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");
const { ethers } = require("hardhat");

const deployment = buildModule("Deploy", (mod) => {
  const contract = mod.contract("DutchAuction", []);

  mod.call(contract, "safeMint", [1], { value: ethers.parseEther("5") });

  mod.call(contract, "balanceOf", [
    "0xf39fd6e51aad88f6f4ce6ab8827279cfffb92266",
  ]);

  return { contract };
});

module.exports = deployment;
