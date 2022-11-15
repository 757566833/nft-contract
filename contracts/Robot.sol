// SPDX-License-Identifier: UNLICENSED
pragma solidity =0.8.17;

// Uncomment this line to use console.log
// import "hardhat/console.sol";
import "./interfaces/IErc721.sol";

contract Robot {
    string private __version;
    event Buy(
        address indexed contractAddress,
        uint256 indexed tokenId,
        uint256 indexed price
    );

    constructor(string memory _versoion) {
        __version = _versoion;
    }

    function version() public view returns (string memory) {
        return __version;
    }

    function buy(
        address c,
        address to,
        uint256 tokenId,
                address[] memory _creatorAddress,
        uint8[] memory _creatorRate
    ) external payable {
         require(
            _creatorAddress.length == _creatorRate.length,
            "creator address length not equal to creator reate length"
        );
        emit Buy(c, tokenId, msg.value);
        IErc721(c).buy{value: msg.value}(tokenId, to,_creatorAddress,_creatorRate);
    }
}
