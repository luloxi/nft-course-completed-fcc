// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

error HardhatBasicsNFT__WrongValue();

interface IHardhatBasicsNFT {
    function TOKEN_IMAGE_URI()
        external
        view
        returns (string memory ipfsAddress);

    function mintNft(uint256 valueAtSevenSevenSeven)
        external
        returns (uint256 s_tokenCounter);

    function tokenURI(
        uint256 /* tokenId */
    ) external view returns (string memory applicationData);

    function getTokenCounter() external view returns (uint256 tokenCount);
}
