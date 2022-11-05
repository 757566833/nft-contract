// contracts/Gold721.sol
// SPDX-License-Identifier: MIT
pragma solidity =0.8.17;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./interfaces/IErc721.sol";

contract Erc721 is ERC721URIStorage, IErc721, Ownable {
    string private __name;
    string private __symbol;
    string private __version;
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    constructor() ERC721("ERC721", "E721") {}

    mapping(uint256 => uint256) tokenList;
    mapping(address => uint256) value;

    event Sell(uint256 indexed tokenId, uint256 indexed price);
    // 主动下架是1 被购买下架是2
    event CancelSell(uint256 indexed tokenId, uint8 indexed status);
    event WithDraw(uint256 indexed value);

    function transferContractOwnership(address newOwner) external onlyOwner {
        super.transferOwnership(newOwner);
    }

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

    function version() public view returns (string memory) {
        return __version;
    }

    function initialize(
        string memory _name,
        string memory _symbol,
        string memory _verison
    ) public {
        __name = _name;
        __symbol = _symbol;
        __version = _verison;
    }

    function sell(uint256 tokenId, uint256 price) public {
        require(
            ownerOf(tokenId) == msg.sender,
            "Permission denied:nft it's not yours"
        );
        require(price > 0, "price must more than the 0");
        tokenList[tokenId] = price;
        emit Sell(tokenId, price);
    }

    function cancelSell(uint256 tokenId) public {
        require(
            ownerOf(tokenId) == msg.sender,
            "Permission denied:nft it's not yours"
        );
        require(tokenList[tokenId] > 0, "not selling");
        delete tokenList[tokenId];
        emit CancelSell(tokenId, 1);
    }

    function buy(uint256 tokenId, address to) public payable {
        require(tokenList[tokenId] != 0, "Item not selling");
        require(msg.value == tokenList[tokenId], "Incorrect price");
        value[ownerOf(tokenId)] = msg.value;
        delete tokenList[tokenId];
        safeTransferFrom(ownerOf(tokenId), to, tokenId);
        emit CancelSell(tokenId, 2);
    }

    function withDraw(uint256 _value) public {
        require(_value <= value[msg.sender], "Insufficient balance");
        address payable sender = payable(msg.sender);
        sender.transfer(_value);
        value[msg.sender] = value[msg.sender] - _value;
        emit WithDraw(_value);
    }

    /**
     * @dev See {IERC721-transferFrom}.
     */
    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) public virtual override {
        require(tokenList[tokenId] == 0, "Item is selling");
        super.transferFrom(from, to, tokenId);
    }

    /**
     * @dev See {IERC721-safeTransferFrom}.
     */
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId
    ) public virtual override {
        require(tokenList[tokenId] == 0, "Item is selling");
        super.safeTransferFrom(from, to, tokenId);
    }

    /**
     * @dev See {IERC721-safeTransferFrom}.
     */
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId,
        bytes memory data
    ) public virtual override {
        require(tokenList[tokenId] == 0, "Item is selling");
        super.safeTransferFrom(from, to, tokenId, data);
    }
}
