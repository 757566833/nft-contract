// contracts/Gold20.sol
// SPDX-License-Identifier: MIT
pragma solidity =0.8.17;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

interface IErc1155 {
    function mint(
        string memory name,
        string memory tokenURI,
        uint256 amount,
        string memory db
    ) external;

    function mintAndTransfer(
        address owner,
        string memory name,
        string memory tokenURI,
        uint256 amount,
        uint256 buyAmout,
        string memory db
    ) external payable;

    function version() external view returns (string memory);

    function count() external view returns (uint256);

    // function isApprovedForAll(address account, address operator)
    //     external
    //     view
    //     returns (bool);
}
