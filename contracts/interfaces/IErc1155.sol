// contracts/Gold20.sol
// SPDX-License-Identifier: MIT
pragma solidity =0.8.17;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

interface IErc1155 {
    function mint(
        uint256 tokenId,
        string memory name,
        string memory tokenURI,
        uint256 amount
    ) external;

    function mintAndBuy(
        uint256 tokenId,
        address from,
        address to,
        string memory name,
        string memory tokenURI,
        uint256 amount
    ) external payable;
    
    function buy(
        uint256 tokenId,
        address from,
        address to,
        uint256 amount
    ) external payable;

    function version() external view returns (string memory);
}
