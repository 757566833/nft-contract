// contracts/Gold20.sol
// SPDX-License-Identifier: MIT
pragma solidity =0.8.17;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

interface IErc721  is IERC721{
    function transferContractOwnership(address newOwner) external;

    function mint(address account, string memory tokenURI) external;

    function initialize(
        string memory _name,
        string memory _symbol,
        string memory _verison,
        address _robot
    ) external;
     function currentId () external  view returns (uint256);

    // function sell(uint256 tokenId, uint256 price) external;

    // function cancelSell(uint256 tokenId) external;

    // function buy(
    //     uint256 tokenId,
    //     address to
    //     // address[] memory _creatorAddress,
    //     // uint8[] memory _creatorRate
    // ) external payable;
    // function ownerOfTokenId(uint256 tokenId) external view returns (address owner);
}
