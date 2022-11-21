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

    function mint1155(
        address c,
        address to,
        uint256 tokenId,
        string memory name,
        string memory tokenURI,
        uint256 amount
    ) external payable {
        IErc1155(c).mint(to, tokenId, name, tokenURI, amount);
    }

    function buy1155(
        address c,
        string memory orderId,
        string memory orderHash,
        uint256 tokenId,
        address from,
        address to,
        uint256 amount
    ) external payable {
        IErc1155(c).buy{value: msg.value}(orderId,orderHash,tokenId, from, to, amount);
    }

    function batchBuy1155(
        address c,
         string[] memory orderIds,
        string[] memory orderHashs,
        address[] memory froms,
        address[] memory tos,
        uint256[] memory ids,
        uint256[] memory amounts,
        string[] memory tokenURIs,
        string[] memory names,
        uint256[] memory values
    ) external payable {
        IErc1155(c).batchBuy{value: msg.value}(orderIds,orderHashs,froms, tos, ids, amounts, tokenURIs, names, values);
    }

    function mintAndBuy1155(
        address c,
        string memory orderId,
        string memory orderHash,
        uint256 tokenId,
        address from,
        address to,
        string memory name,
        string memory tokenURI,
        uint256 amount
    ) external payable {
        IErc1155(c).mintAndBuy{value: msg.value}(
            orderId,
            orderHash,
            tokenId,
            from,
            to,
            name,
            tokenURI,
            amount
        );
    }
}
