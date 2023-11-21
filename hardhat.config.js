require("@nomiclabs/hardhat-ethers");
require("@nomiclabs/hardhat-etherscan");

const YOUR_PRIVATE_KEY = process.env.PRIVATE_KEY;
const BSCSCAN_API_KEY = process.env.BSCSCAN_API_KEY;

require("dotenv").config();

module.exports = {
  solidity: "0.8.20",
  networks: {
    mainnet: {
      url: "https://bsc-dataseed.binance.org/",
      accounts: [`0x${YOUR_PRIVATE_KEY}`],
      chainId: 56,
    },
    testnet: {
      url: "https://data-seed-prebsc-1-s1.binance.org:8545/",
      accounts: [`0x${YOUR_PRIVATE_KEY}`],
      chainId: 97,
    }
  },
  bscscan: {
    apiKey: BSCSCAN_API_KEY
  }
};