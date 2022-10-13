// contracts/Gold20.sol
// SPDX-License-Identifier: MIT
pragma solidity =0.8.17;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

interface IErc721 is IERC721 {
    function initialize(string memory name, string memory symbol) external;
    function transferOwnership(address newOwner) external  ;

}
