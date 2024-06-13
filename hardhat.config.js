require("@nomicfoundation/hardhat-toolbox");
require("@nomicfoundation/hardhat-ignition");
require("dotenv").config();

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.24",
  networks: {
    amoy: {
      url: process.env.PROVIDER_URL,
      accounts: [`0x${process.env.PRIVATE_KEY}`],
    },
    sepolia: {
      url: process.env.SEPOLIA_PROVIDER_URL,
      accounts: [`0x${process.env.PRIVATE_KEY}`],
    },
  },
};
