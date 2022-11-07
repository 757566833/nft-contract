// contracts/Gold20.sol
// SPDX-License-Identifier: MIT
pragma solidity =0.8.17;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

interface IErc721 {
    function transferContractOwnership(address newOwner) external;

    function mint(address account, string memory tokenURI)
        external
        returns (uint256);

    function initialize(
        string memory _name,
        string memory _symbol,
        string memory _version
    ) external;

    function sell(uint256 tokenId, uint256 price) external;

    function cancelSell(uint256 tokenId) external;

    function buy(uint256 tokenId, address to) external payable;

    function valueOf(address _user) external view returns (uint256);

    function withDraw(uint256 _value) external;
}
