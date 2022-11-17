// SPDX-License-Identifier: UNLICENSED
pragma solidity =0.8.17;

// Uncomment this line to use console.log
// import "hardhat/console.sol";
import "./interfaces/IErc721.sol";
import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155URIStorage.sol";
import "./interfaces/IErc1155.sol";

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

    function buy721(
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
        IErc721(c).buy{value: msg.value}(
            tokenId,
            to,
            _creatorAddress,
            _creatorRate
        );
    }

function buy1155(
        address c,
       uint256 tokenId,
        address from,
        address to,
        uint256 amount
    ) external payable {
        IErc1155(c).buy{value: msg.value}(
            tokenId,
            from,
            to,
            amount
        );
    }

    function mintAndBuy1155(
        address c,
        uint256 tokenId,
        address from,
        address to,
        string memory name,
        string memory tokenURI,
        uint256 amount
    ) external payable {
        IErc1155(c).mintAndBuy{value: msg.value}(
            tokenId,
            from,
            to,
            name,
            tokenURI,
            amount
        );
    }

}
