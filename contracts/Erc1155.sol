// contracts/Gold721.sol
// SPDX-License-Identifier: MIT
pragma solidity =0.8.17;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Erc1155 is ERC1155URIStorage, Ownable {
    string private _version;
    string private _symbol;
    using Counters for Counters.Counter;
    Counters.Counter private _count;

    mapping(uint256 => string) private _names;
    mapping(uint256 => uint256) private _maxs;
    mapping(uint256 => address) private _owners;
    mapping(uint256 => uint256) private _totals;

    event Created(address indexed op, uint256 indexed num, uint256 indexed max);
    event Info(
        string indexed name,
        string indexed collectionId,
        string indexed tokenURI
    );

    constructor(string memory __verison) ERC1155("") {
        _version = __verison;
    }

    function create(
        string memory name,
        string memory collectionId,
        uint256 max,
        string memory tokenURI
    ) public {
        _count.increment();
        uint256 index = _count.current();
        _setURI(index, tokenURI);
        _names[index] = name;
        _maxs[index] = max;
        _owners[index] = msg.sender;
        emit Created(msg.sender, index, max);
        emit Info(name, collectionId, tokenURI);
    }

    function mint(
        address account,
        uint256 id,
        uint256 amount
    ) public {
        require(msg.sender == _owners[id]);
        require(_totals[id]+amount<=_maxs[id]);
        _mint(account, id, amount, "");
    }

    function version() public view returns (string memory) {
        return _version;
    }

    function count() public view returns (uint256) {
        return _count.current();
    }
}
