const { getNamedAccounts, ethers } = require("hardhat");

async function main() {
  const accounts = await ethers.getSigners();
  const deployer = accounts[0];

  const courseCompletedNFT = await ethers.getContractAt(
    "CourseCompletedNFT",
    "0x9E9a4e58dDc9483d241AfC9a028E89BD9b9fa683",
    deployer
  );
  console.log("Connected to CourseCompletedNFT contract!");

  console.log("Deploying Attacker contract...");
  await deployments.fixture("all");
  const attacker = await ethers.getContract("Attacker", deployer);

  console.log("Sending mintNft transaction...");
  const selector = await attacker.getSelector();
  const attackTx = await courseCompletedNFT.mintNft(attacker.address, selector);
  attackTx.wait(1);
  console.log("Minted!");
}

// Call th main function and log errors if any occur
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
