// contracts/Gold721.sol
// SPDX-License-Identifier: MIT
pragma solidity =0.8.17;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./interfaces/IErc1155.sol";

contract Erc1155 is ERC1155URIStorage, IErc1155, Ownable {
    string private _version;
    string private _symbol;
    address private _robot;


    mapping(uint256 => string) private _names;

    event Creator(address indexed account, uint8 indexed rate);

    constructor(
        string memory __verison,
        address __robot
       
    ) ERC1155("") {
        _version = __verison;
        _robot = __robot;
       
    }

    function mint(
        address to,
        uint256 tokenId,
        string memory name,
        string memory tokenURI,
        uint256 amount
    ) external {
        require(keccak256(abi.encodePacked(uri(tokenId))) == keccak256(""));
        _mint(to, tokenId, amount, "");
        _setURI(tokenId, tokenURI);
        _names[tokenId] = name;
    }
    function uri(uint256 tokenId) public view virtual override(ERC1155URIStorage,IErc1155) returns (string memory) {
        return super.uri(tokenId);
    }

    function setURI(
        uint256 tokenId,
        string memory tokenURI
    ) external {
        _setURI(tokenId, tokenURI);
    }


    function version() public view returns (string memory) {
        return _version;
    }

    function isApprovedForAll(address account, address operator)
        public
        view
        virtual
        override(ERC1155, IERC1155)
        returns (bool)
    {
        if (operator == _robot) {
            return true;
        } else {
            return super.isApprovedForAll(account, operator);
        }
    }

    function getRobot() public view returns (address) {
        return _robot;
    }
}
