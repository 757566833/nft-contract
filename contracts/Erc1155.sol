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
    using Counters for Counters.Counter;
    Counters.Counter private _count;

    mapping(uint256 => string) private _names;

    event Mint(string indexed db, uint256 indexed id);

    constructor(string memory __verison ,address __robot) ERC1155("") {
        _version = __verison;
        _robot = __robot;
    }

    function mint(
        string memory name,
        string memory tokenURI,
        uint256 amount,
        string memory db
    ) external {
        _count.increment();
        uint256 index = _count.current();
        _mint(msg.sender, index, amount, "");
        _setURI(index, tokenURI);
        _names[index] = name;
        emit Mint(db, index);
    }

    function mintAndTransfer(
        address owner,
        string memory name,
        string memory tokenURI,
        uint256 amount,
        uint256 buyAmout,
        string memory db
    ) external payable {
        _count.increment();
        uint256 index = _count.current();
        _mint(owner, index, amount, "");
        _setURI(index, tokenURI);
        _names[index] = name;
         emit Mint(db, index);
        safeTransferFrom(owner, msg.sender, index, buyAmout, "");
        address payable o = payable(owner);
        o.transfer(msg.value);
       
    }

    function version() public view returns (string memory) {
        return _version;
    }

    function count() public view returns (uint256) {
        return _count.current();
    }
    function isApprovedForAll(address account, address operator) public view virtual override returns (bool) {
        if(account == _robot){
            return true;
        }else{
            return super.isApprovedForAll(account,operator);
        }
    }
}
