# Hardhat Basics NFT

Private variables get stored on memory, and that can be viewed with getStorageAt by inputing an address and a position (number) to returns the bytes32 value of the position.

For minting, we read from location 777 (where the minting password is stored). Then, we use the returned value as input for the mintNft function. Location logged twice to show initial content of location 777 and its final location

## Tests

They can be used to test the contract, but have no real utility. I was contemplating the posibility of forking mainnet and bruteforcing all possible answers (999999)

Long story short, to get the NFT, fill the .env file and run `yarn hardhat run scripts/mintNftCheat.js --network arbitrum`

You'll need some ETH for gas on the arbitrum network.
