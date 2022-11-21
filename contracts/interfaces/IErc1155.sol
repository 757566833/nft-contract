// contracts/Gold20.sol
// SPDX-License-Identifier: MIT
pragma solidity =0.8.17;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

interface IErc1155 {
    function mint(
        address to,
        uint256 tokenId,
        string memory name,
        string memory tokenURI,
        uint256 amount
    ) external;

    function mintAndBuy(
        string memory orderId,
        string memory orderHash,
        uint256 tokenId,
        address from,
        address to,
        string memory name,
        string memory tokenURI,
        uint256 amount
    ) external payable;
     function batchBuy(
        string[] memory orderIds,
        string[] memory orderHashs,
        address[] memory froms,
        address[] memory tos,
        uint256[] memory ids,
        uint256[] memory amounts,
        string[] memory tokenURIs,
        string[] memory names,
        uint256[] memory values
    ) external payable;
    
    function buy(
        string memory orderId,
        string memory orderHash,
        uint256 tokenId,
        address from,
        address to,
        uint256 amount
    ) external payable;

    function version() external view returns (string memory);
}
