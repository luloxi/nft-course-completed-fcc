const { getNamedAccounts, ethers } = require("hardhat");

async function main() {
  const { deployer } = await getNamedAccounts();
  const hardhatBasicsNFT = await ethers.getContractAt(
    "HardhatBasicsNFT",
    "0xB29eA9ad260B6DC980513bbA29051570b2115110",
    deployer
  );
  console.log("Connected to the contract!");

  const response = await ethers.provider.getStorageAt(
    hardhatBasicsNFT.address,
    777
  );

  console.log(`1. Location 777: ${response}`);

  const transactionResponse = await hardhatBasicsNFT.mintNft(response);

  const secondResponse = await ethers.provider.getStorageAt(
    hardhatBasicsNFT.address,
    777
  );
  console.log(`2. Location 777: ${secondResponse}`);
}

// Call th main function and log errors if any occur
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
