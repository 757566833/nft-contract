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
    string private _salt;

    mapping(uint256 => string) private _names;

    event Mint(uint256 indexed id, uint256 indexed amount);

    constructor(string memory __verison, address __robot, string memory __salt) ERC1155("") {
        _version = __verison;
        _robot = __robot;
        _salt = __salt;
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
        emit Mint(tokenId, amount);
    }
    function stringToBytes32(string memory source) pure public returns (bytes32 result){
        assembly {
            result:=mload(add(source,32))
        }
    }
    function mintAndBuy(
        string memory orderId,
        string memory orderHash,
        uint256 tokenId,
        address from,
        address to,
        string memory name,
        string memory tokenURI,
        uint256 amount
    ) external payable {
        require(keccak256(abi.encodePacked(_salt,orderId,msg.value))==stringToBytes32(orderHash));
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
        require(
            (froms.length == tos.length) &&
                (tos.length == ids.length) &&
                (ids.length == amounts.length) &&
                (amounts.length == tokenURIs.length) &&
                (tokenURIs.length == names.length) &&
                (names.length == values.length)
        );
        uint256 total = 0;
        for (uint256 index = 0; index < values.length; index++) {
            total += values[index];
        }
        require(msg.value >= total);
        for (uint256 index = 0; index < orderHashs.length; index++) {
             require(keccak256(abi.encodePacked(_salt,orderIds[index],values[index]))==stringToBytes32(orderHashs[index]));
        }
       
        
        for (uint256 index = 0; index < froms.length; index++) {
            address from = froms[index];
            address to = tos[index];
            uint256 id = ids[index];
            uint256 amount = amounts[index];
            string memory tokenURI = tokenURIs[index];
            string memory name = names[index];
            if (keccak256(abi.encodePacked(uri(id))) == keccak256("")) {
                _mint(from, id, amount, "");
                _setURI(id, tokenURI);
                _names[id] = name;
                emit Mint(id, amount);
            } else if (balanceOf(from, id) < amount) {
                uint256 b = balanceOf(from, id);
                _mint(from, id, amount - b, "");
                emit Mint(id, amount - b);
            }
            safeTransferFrom(from, to, id, amount, "");
        }
    }

    function buy(
         string memory orderId,
        string memory orderHash,
        uint256 tokenId,
        address from,
        address to,
        uint256 amount
    ) external payable {
         require(keccak256(abi.encodePacked(_salt,orderId,msg.value))==stringToBytes32(orderHash));
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
