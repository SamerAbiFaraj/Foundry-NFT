//SPDX-License-Identifier:MIT

pragma solidity ^0.8.19;

import {Test} from "forge-std/Test.sol";
import {BasicNft} from "../src/BasicNft.sol";
import {DeployBasicNft} from "../script/DeployBasicNft.s.sol";

contract BasicNftTest is Test {
    DeployBasicNft public deployBasicNft;
    BasicNft public basicNft;
    address public USER = makeAddr("user");
    string public constant PUG_URI =
        "ipfs://bafybeig37ioir76s7mg5oobetncojcm3c3hxasyd4rvid4jqhy4gkaheg4/?filename=0-PUG.json";

    function setUp() public {
        deployBasicNft = new DeployBasicNft();
        basicNft = deployBasicNft.run();
    }

    function testNameIsCorrect() external view {
        string memory expectedName = "Dogie";
        string memory actualName = basicNft.name();

        //assertEq(actualName, expectedName);
        //OR

        //since array of strings we need to use keccak256 bc cant compare strings
        assert(
            keccak256(abi.encodePacked(expectedName)) ==
                keccak256(abi.encodePacked(actualName))
        );
    }

    function testCanMintAndHaveABalance() public {
        vm.prank(USER);
        basicNft.mintNFT(PUG_URI);
        uint256 getCounter = basicNft.getTokenCounter() - 1;

        assert(basicNft.balanceOf(USER) == 1);
        assert(
            keccak256(abi.encodePacked(PUG_URI)) ==
                keccak256(abi.encodePacked(basicNft.tokenURI(getCounter)))
        );
    }
}
