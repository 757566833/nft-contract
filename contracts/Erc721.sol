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
    address private __robot;
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    constructor() ERC721("ERC721", "E721") {}

   

    function transferContractOwnership(address newOwner) external onlyOwner {
        super.transferOwnership(newOwner);
    }
    

    function mint(address account, string memory tokenURI)
        public returns (uint256)
    {
        _tokenIds.increment();
        uint256 newItemId = _tokenIds.current();
        _mint(account, newItemId);
        _setTokenURI(newItemId, tokenURI);
        // // event Mint(uint256 indexed tokenId,string indexed collectionId);
        // emit Mint(newItemId, collectionId,createBy);
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
        string memory _verison,
        address _robot
    ) public {
       
        __name = _name;
        __symbol = _symbol;
        __version = _verison;
        __robot = _robot;
    }
    function isApprovedForAll(address account, address operator)
        public
        view
        virtual
        override(ERC721,IERC721)
        returns (bool)
    {
        if (operator == __robot) {
            return true;
        } else {
            return super.isApprovedForAll(account, operator);
        }
    }

    function getRobot() public view returns (address) {
        return __robot;
    }

    // function sell(uint256 tokenId, uint256 price) public {
    //     require(
    //         ownerOf(tokenId) == msg.sender,
    //         "Permission denied:nft it's not yours"
    //     );
    //     require(price > 0, "price must more than the 0");
    //     tokenList[tokenId] = price;
    //     emit Sell(tokenId, price);
    // }

    // function cancelSell(uint256 tokenId) public {
    //     require(
    //         ownerOf(tokenId) == msg.sender,
    //         "Permission denied:nft it's not yours"
    //     );
    //     require(tokenList[tokenId] > 0, "not selling");
    //     delete tokenList[tokenId];
    //     emit CancelSell(tokenId, 1);
    // }

    // function buy(
    //     uint256 tokenId,
    //     address to
    //     // address[] memory _creatorAddress,
    //     // uint8[] memory _creatorRate
    // ) public payable {
    //     //  require(
    //     //     _creatorAddress.length == _creatorRate.length,
    //     //     "creator address length not equal to creator reate length"
    //     // );
    //     require(tokenList[tokenId] != 0, "Item not selling");
    //     require(msg.value == tokenList[tokenId], "Incorrect price");
    //     emit CancelSell(tokenId, 2);
    //     address payable from = payable(ownerOf(tokenId));
    //     delete tokenList[tokenId];
    //     safeTransferFrom(ownerOf(tokenId), to, tokenId);
    //     uint256 _value = msg.value;
    //     // for (uint256 index = 0; index < _creatorAddress.length; index++) {
    //     //     address payable user = payable(_creatorAddress[index]);
    //     //     uint256 currentValue = (_creatorRate[index] * msg.value) / 100;
    //     //     user.transfer(currentValue);
    //     //     _value = _value - currentValue;
    //     //     emit Creator(user, _creatorRate[index]);
    //     // }
    //     from.transfer(_value);
    // }

    // /**
    //  * @dev See {IERC721-transferFrom}.
    //  */
    // function transferFrom(
    //     address from,
    //     address to,
    //     uint256 tokenId
    // ) public virtual override {
    //     require(tokenList[tokenId] == 0, "Item is selling");
    //     super.transferFrom(from, to, tokenId);
    // }

    // /**
    //  * @dev See {IERC721-safeTransferFrom}.
    //  */
    // function safeTransferFrom(
    //     address from,
    //     address to,
    //     uint256 tokenId
    // ) public virtual override {
    //     require(tokenList[tokenId] == 0, "Item is selling");
    //     super.safeTransferFrom(from, to, tokenId);
    // }

    // /**
    //  * @dev See {IERC721-safeTransferFrom}.
    //  */
    // function safeTransferFrom(
    //     address from,
    //     address to,
    //     uint256 tokenId,
    //     bytes memory data
    // ) public virtual override {
    //     require(tokenList[tokenId] == 0, "Item is selling");
    //     super.safeTransferFrom(from, to, tokenId, data);
    // }

    // function ownerOfTokenId(uint256 tokenId) external view returns (address owner){
    //     return super.ownerOf(tokenId);
    // }
}
