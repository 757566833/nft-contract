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
    }

    function bytesToHex(bytes memory buffer)
        public
        pure
        returns (string memory)
    {
        // Fixed buffer size for hexadecimal convertion
        bytes memory converted = new bytes(buffer.length * 2);

        bytes memory _base = "0123456789abcdef";

        for (uint256 i = 0; i < buffer.length; i++) {
            converted[i * 2] = _base[uint8(buffer[i]) / _base.length];
            converted[i * 2 + 1] = _base[uint8(buffer[i]) % _base.length];
        }

        return string(abi.encodePacked("0x", converted));
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
    ) external payable {
        string memory s = bytesToHex(
            bytes.concat(
                keccak256(abi.encodePacked(_salt, orderId, uint2str(msg.value)))
            )
        );
        require(
            keccak256(abi.encodePacked(s)) ==
                keccak256(abi.encodePacked(orderHash)),
            "hash is error"
        );

        if (keccak256(abi.encodePacked(uri(tokenId))) == keccak256("")) {
            _setURI(tokenId, tokenURI);
            _mint(from, tokenId, amount, "");
            _names[tokenId] = name;
        } else if (balanceOf(from, tokenId) < amount) {
            uint256 b = balanceOf(from, tokenId);
            _mint(from, tokenId, amount - b, "");
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
