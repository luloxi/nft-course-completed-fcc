const { network } = require("hardhat");

module.exports = async ({ getNamedAccounts, deployments }) => {
  const { deploy, log } = deployments;
  const { deployer } = await getNamedAccounts();
  const chainId = network.config.chainId;

  const vulnerableContract = await deploy("Attacker", {
    from: deployer,
    log: true,
    waitConfirmations: network.config.blockConfirmations || 1,
  });

  log("-------------------------------------");

  log("Logging storage...");
  const transactionResponse = await ethers.provider.getStorageAt(
    hardhatBasicsNFT.address,
    777
  );
  const transactionReceipt = transactionResponse.toString();
  log(`Location 777: ${transactionReceipt}`);
};

module.exports.tags = ["all", "hardhatbasicsnft"];
