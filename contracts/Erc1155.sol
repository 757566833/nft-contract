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
    event Creator(address indexed account, uint8 indexed rate);

    constructor(
        string memory __verison,
        address __robot,
        string memory __salt
    ) ERC1155("") {
        _version = __verison;
        _robot = __robot;
        _salt = __salt;
    }

    function uint2str(uint256 _i)
        internal
        pure
        returns (string memory _uintAsString)
    {
        if (_i == 0) {
            return "0";
        }
        uint256 j = _i;
        uint256 len;
        while (j != 0) {
            len++;
            j /= 10;
        }
        bytes memory bstr = new bytes(len);
        uint256 k = len;
        while (_i != 0) {
            k = k - 1;
            uint8 temp = (48 + uint8(_i - (_i / 10) * 10));
            bytes1 b1 = bytes1(temp);
            bstr[k] = b1;
            _i /= 10;
        }
        return string(bstr);
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

    function stringToBytes32(string memory source)
        public
        pure
        returns (bytes32 result)
    {
        assembly {
            result := mload(add(source, 32))
        }
    }

    // function mintAndBuy(
    //     string memory orderId,
    //     string memory orderHash,
    //     uint256 tokenId,
    //     address from,
    //     address to,
    //     string memory name,
    //     string memory tokenURI,
    //     uint256 amount
    // ) external payable {
    //     require(
    //         keccak256(abi.encodePacked(_salt, orderId, uint2str(msg.value))) ==
    //             stringToBytes32(orderHash)
    //     );
    //     require(keccak256(abi.encodePacked(uri(tokenId))) == keccak256(""));
    //     _mint(from, tokenId, amount, "");
    //     _setURI(tokenId, tokenURI);
    //     _names[tokenId] = name;
    //     emit Mint(tokenId, amount);
    //     safeTransferFrom(from, to, tokenId, amount, "");
    //     address payable o = payable(from);
    //     o.transfer(msg.value);
    // }

    function batchBuy(
        string[] memory orderIds,
        string[] memory orderHashs,
        address[] memory froms,
        address[] memory tos,
        uint256[] memory tokenIds,
        uint256[] memory amounts,
        string[] memory tokenURIs,
        string[] memory names,
        uint256[] memory values
        // address[][] memory creatorAddresses,
        // uint8[][] memory creatorRates
    ) external payable {
        require(
            (froms.length == tos.length) &&
                (tos.length == tokenIds.length) &&
                (tokenIds.length == amounts.length) &&
                (amounts.length == tokenURIs.length) &&
                (tokenURIs.length == names.length) &&
                (names.length == values.length)
        );
        uint256 total = 0;
        for (uint256 index = 0; index < values.length; index++) {
            require(balanceOf(froms[index], tokenIds[index]) >= amounts[index]);
            total += values[index];
        }
        require(msg.value >= total);
        for (uint256 index = 0; index < orderHashs.length; index++) {
            require(
                keccak256(
                    abi.encodePacked(_salt, orderIds[index], values[index])
                ) == stringToBytes32(orderHashs[index])
            );
        }

        for (uint256 index = 0; index < froms.length; index++) {
            address from = froms[index];
            address to = tos[index];
            uint256 tokenId = tokenIds[index];
            uint256 amount = amounts[index];
            string memory tokenURI = tokenURIs[index];
            string memory name = names[index];
            uint256 value = values[index];
            // address[] memory creatorAddress = creatorAddresses[index];
            // uint8[] memory creatorRate = creatorRates[index];
            if (keccak256(abi.encodePacked(uri(tokenId))) == keccak256("")) {
                _mint(from, tokenId, amount, "");
                _setURI(tokenId, tokenURI);
                _names[tokenId] = name;
                emit Mint(tokenId, amount);
            } else if (balanceOf(from, tokenId) < amount) {
                uint256 b = balanceOf(from, tokenId);
                _mint(from, tokenId, amount - b, "");
                emit Mint(tokenId, amount - b);
            }
            uint256 _value = value;
            // for (uint256 i = 0; i < creatorAddress.length; i++) {
            //     address payable user = payable(creatorAddress[i]);
            //     uint256 currentValue = (creatorRate[i] * value) / 100;
            //     user.transfer(currentValue);
            //     _value = _value - currentValue;
            //     emit Creator(user, creatorRate[i]);
            // }
            safeTransferFrom(from, to, tokenId, amount, "");
            address payable o = payable(from);
            o.transfer(_value);
        }
    }

    function buy(
        string memory orderId,
        string memory orderHash,
        address from,
        address to,
        uint256 tokenId,
        uint256 amount,
        string memory tokenURI,
        string memory name
        // address[] memory creatorAddresses,
        // uint8[] memory creatorRates
    ) external payable {
        require(
            keccak256(abi.encodePacked(_salt, orderId, uint2str(msg.value))) ==
                stringToBytes32(orderHash)
        );
        require(keccak256(abi.encodePacked(uri(tokenId))) != keccak256(""));

        if (keccak256(abi.encodePacked(uri(tokenId))) == keccak256("")) {
            _mint(from, tokenId, amount, "");
            _setURI(tokenId, tokenURI);
            _names[tokenId] = name;
            emit Mint(tokenId, amount);
        } else if (balanceOf(from, tokenId) < amount) {
            uint256 b = balanceOf(from, tokenId);
            _mint(from, tokenId, amount - b, "");
            emit Mint(tokenId, amount - b);
        }
        uint256 _value = msg.value;
        // for (uint256 i = 0; i < creatorAddresses.length; i++) {
        //     address payable user = payable(creatorAddresses[i]);
        //     uint256 currentValue = (creatorRates[i] * msg.value) / 100;
        //     user.transfer(currentValue);
        //     _value = _value - currentValue;
        //     emit Creator(user, creatorRates[i]);
        // }
        safeTransferFrom(from, to, tokenId, amount, "");
        address payable o = payable(from);
        o.transfer(_value);
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
