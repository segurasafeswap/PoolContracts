require("@nomiclabs/hardhat-ethers");


module.exports = {
  solidity: "0.8.21",
  paths: {
    sources: "./contracts",
    tests: "./test",
    cache: "./cache",
    artifacts: "./artifacts"
  },
  networks: {
    hardhat: {
      // Configuration for the Hardhat network
    }
    // Additional network configurations (e.g., Rinkeby, Mainnet)
  }
};