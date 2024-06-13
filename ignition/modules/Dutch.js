const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");
require("dotenv").config();

module.exports = buildModule("Deploy", (mod) => {
  const contract = mod.contract("DutchAuction", []);

  return { contract };
});
