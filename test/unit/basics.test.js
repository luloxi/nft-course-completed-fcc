const { deployments, ethers, getNamedAccounts } = require("hardhat");
const { assert, expect } = require("chai");

describe("Hardhat Basics NFT Cheater", function () {
  let hardhatBasicsNFT;
  let deployer;
  beforeEach(async function () {
    await deployments.fixture(["all"]);
    const deployer = (await getNamedAccounts()).deployer;
    hardhatBasicsNFT = await ethers.getContract("HardhatBasicsNFT", deployer);
  });

  describe("after initial deploy", function () {
    it("returns an error on incorrect guess", async function () {
      await expect(hardhatBasicsNFT.mintNft(11)).to.be.revertedWith(
        "HardhatBasicsNFT__WrongValue()"
      );
    });
    it("Adds new minted NFT to token counter", async function () {
      const startingTokenCounter = await hardhatBasicsNFT.getTokenCounter();
      const transactionResponse = await hardhatBasicsNFT.mintNft(123);
      const transactionReceipt = await transactionResponse.wait(1);
      const endingTokenCounter = await hardhatBasicsNFT.getTokenCounter();
      assert.equal(
        startingTokenCounter.add(1).toString(),
        endingTokenCounter.toString()
      );
    });
    it("Changes answer after first mint", async function () {
      const transactionResponse = await hardhatBasicsNFT.mintNft(123);
      const transactionReceipt = await transactionResponse.wait(1);
      await expect(hardhatBasicsNFT.mintNft(123)).to.be.revertedWith(
        "HardhatBasicsNFT__WrongValue()"
      );
    });
  });
});
