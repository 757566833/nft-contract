// contracts/Gold721.sol
// SPDX-License-Identifier: MIT
pragma solidity =0.8.17;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Erc721 is ERC721URIStorage, Ownable {
    string private __name;
    string private __symbol;
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    constructor() ERC721("Gold721", "G721") {}

    mapping(uint256 => uint256) tokenList;

    function mint(address account, string memory tokenURI)
        public
        onlyOwner
        returns (uint256)
    {
        _tokenIds.increment();
        uint256 newItemId = _tokenIds.current();
        _mint(account, newItemId);
        _setTokenURI(newItemId, tokenURI);
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

    function sell(uint256 tokenId, uint256 price) public {
        require(
            ownerOf(tokenId) == msg.sender,
            "Permission denied:nft it's not yours"
        );
        tokenList[tokenId] = price;
    }

    function cancelSell(uint256 tokenId, uint256 price) public {
        require(
            ownerOf(tokenId) == msg.sender,
            "Permission denied:nft it's not yours"
        );
        tokenList[tokenId] = price;
        delete tokenList[tokenId];
    }
    function buy (uint256 tokenId) payable public {
        require(tokenList[tokenId]!=0,"item not selling");
        require(msg.value==tokenList[tokenId],"Incorrect price");
        safeTransferFrom(ownerOf(tokenId), msg.sender, tokenId);
    }
}
