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

    event Mint(uint256 indexed id, uint256 indexed amount);

    constructor(string memory __verison, address __robot) ERC1155("") {
        _version = __verison;
        _robot = __robot;
    }

    function mint(
        uint256 tokenId,
        string memory name,
        string memory tokenURI,
        uint256 amount
    ) external {
        require(keccak256(abi.encodePacked(uri(tokenId))) == keccak256(""));
        _mint(msg.sender, tokenId, amount, "");
        _setURI(tokenId, tokenURI);
        _names[tokenId] = name;
        emit Mint(tokenId, amount);
    }

    function mintAndBuy(
        uint256 tokenId,
        address from,
        address to,
        string memory name,
        string memory tokenURI,
        uint256 amount
    ) external payable {
        require(keccak256(abi.encodePacked(uri(tokenId))) == keccak256(""));
        _mint(from, tokenId, amount, "");
        _setURI(tokenId, tokenURI);
        _names[tokenId] = name;
        emit Mint(tokenId, amount);
        safeTransferFrom(from, to, tokenId, amount, "");
        address payable o = payable(from);
        o.transfer(msg.value);
    }

    function batchBuy(
        address[] memory from,
        address[] memory to,
        uint256[] memory ids,
        uint256[] memory amounts,
         string[] memory tokenURI,
         string[] memory name,
         bool[] memory isMint
    ) external payable {
        require((from.length==to.length)&&(to.length==ids.length)&&(ids.length==amounts.length)&&(amounts.length==tokenURI.length)&&(tokenURI.length==name.length));
        uint256[] storage unMint;
        for (uint256 index = 0; index < ids.length; index++) {
            if(keccak256(abi.encodePacked(uri(ids[index]))) == keccak256("")){
                // todo
                // unMint.push(ids[index]);
            }
        }
    }

    function buy(
        uint256 tokenId,
        address from,
        address to,
        uint256 amount
    ) external payable {
        require(keccak256(abi.encodePacked(uri(tokenId))) != keccak256(""));
        require(balanceOf(from, tokenId) >= amount);
        safeTransferFrom(from, to, tokenId, amount, "");
        address payable o = payable(from);
        o.transfer(msg.value);
    }

    function version() public view returns (string memory) {
        return _version;
    }

    function isApprovedForAll(address account, address operator)
        public
        view
        virtual
        override
        returns (bool)
    {
        if (account == _robot) {
            return true;
        } else {
            return super.isApprovedForAll(account, operator);
        }
    }
}
