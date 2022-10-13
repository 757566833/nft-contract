// contracts/Gold721.sol
// SPDX-License-Identifier: MIT
pragma solidity =0.8.17;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


contract Gold721 is ERC721URIStorage,Ownable {
     string private __name;
    string private __symbol;
    using Counters for Counters.Counter;
       Counters.Counter private _tokenIds;
       event OnAdd(address account, uint256 newItemId);
    constructor() ERC721("Gold721", "G721"){
        
    }
    function mint(address account, string memory tokenId) public onlyOwner() returns (uint256)  {
        _tokenIds.increment();
        uint256 newItemId = _tokenIds.current();
        _mint(account, newItemId);
        _setTokenURI(newItemId, tokenId);
        emit OnAdd(account, newItemId);
        return newItemId;
    }
    function name() public view virtual override returns (string memory) {
        return __name;
    }

    function symbol() public view virtual override returns (string memory) {
        return __symbol;
    }
    function initialize(string memory _name, string memory _symbol) public {
        __name = _name;
        __symbol = _symbol;
    }
}