// contracts/Gold20.sol
// SPDX-License-Identifier: MIT
pragma solidity =0.8.17;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";

import "@openzeppelin/contracts/access/Ownable.sol";

interface IErc1155  is IERC1155{
    function mint(
        address to,
        uint256 tokenId,
        string memory name,
        string memory tokenURI,
        uint256 amount
    ) external;
    function setURI(
        uint256 tokenId,
        string memory tokenURI
    ) external;
    function uri(uint256 tokenId) external view returns (string memory);
    

     
    // function buy(
    //     string memory orderId,
    //     string memory orderHash,
    //     address from,
    //     address to,
    //     uint256 tokenId,
    //     uint256 amount,
    //     string memory tokenURI,
    //     string memory name
    //     // address[] memory creatorAddresses,
    //     // uint8[] memory creatorRates
    // ) external payable;

    function version() external view returns (string memory);
}