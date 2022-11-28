// SPDX-License-Identifier: UNLICENSED
pragma solidity =0.8.17;

// Uncomment this line to use console.log
// import "hardhat/console.sol";
import "./interfaces/IErc721.sol";
import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155URIStorage.sol";
import "./interfaces/IErc1155.sol";

contract Robot {
    string private __version;
    string private __salt;
    event Buy(
        address indexed contractAddress,
        uint256 indexed cType,
        uint256 indexed tokenId,
        address from,
        address to,
        uint256 amount,
        uint256 price
    );

    // 1155

    event Lock1155(
        address indexed contractAddress,
        string indexed name,
        string indexed tokenURI,
        address to,
        uint256 tokenId,
        uint256 amount
    );

    // 721

    mapping(uint256 => uint256) sell721List;

    event Mint721(
        uint256 indexed tokenId,
        string indexed collectionId,
        address indexed createBy
    );

    event Creator(address indexed account, uint8 indexed rate);

    event Sell(uint256 indexed tokenId, uint256 indexed price);
    // 主动下架是1 被购买下架是2
    event CancelSell(uint256 indexed tokenId, uint8 indexed status);

    constructor(string memory _versoion, string memory _salt) {
        __version = _versoion;
        __salt = _salt;
    }

    function version() public view returns (string memory) {
        return __version;
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

    // 1155
    function batchLockt1155(
        address erc1155,
        address[] memory tos,
        uint256[] memory tokenIds,
        string[] memory names,
        string[] memory tokenURIs,
        uint256[] memory amounts
    ) external payable {
        require(
            (tos.length == tokenIds.length) &&
                (tokenIds.length == amounts.length) &&
                (amounts.length == tokenURIs.length) &&
                (tokenURIs.length == names.length),
            "length not same"
        );
        for (uint256 index = 0; index < tos.length; index++) {
            emit Lock1155(
                erc1155,
                names[index],
                tokenURIs[index],
                tos[index],
                tokenIds[index],
                amounts[index]
            );
            IErc1155(erc1155).mint(
                tos[index],
                tokenIds[index],
                names[index],
                tokenURIs[index],
                amounts[index]
            );
        }
    }

    function batchMint721(
        address erc721,
        address[] memory accounts,
        string[] memory tokenURIs,
        string[] memory collectionIds
    ) public {
        require(
            (accounts.length == tokenURIs.length) &&
                (tokenURIs.length == collectionIds.length),
            "length not same"
        );
        for (uint256 index = 0; index < accounts.length; index++) {
            uint256 tokenId = IErc721(erc721).mint(
                accounts[index],
                tokenURIs[index]
            );
            emit Mint721(tokenId, collectionIds[index], msg.sender);
        }
    }

    // 混合
    function batchAll(
        address[] memory addresses,
        uint256[] memory types,
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
    ) public payable {
        require(
            (addresses.length == types.length) &&
                (types.length == orderIds.length) &&
                (orderIds.length == orderHashs.length) &&
                (orderHashs.length == froms.length) &&
                (froms.length == tos.length) &&
                (tos.length == tokenIds.length) &&
                (tokenIds.length == amounts.length) &&
                (amounts.length == tokenURIs.length) &&
                (tokenURIs.length == names.length) &&
                (names.length == values.length) ,
                // (values.length == creatorAddresses.length) &&
                // (creatorAddresses.length == creatorRates.length),
            "length not same"
        );
        uint256 _total = 0;
        for (uint256 index = 0; index < values.length; index++) {
            _total += values[index];
        }
        require(_total == msg.value, "value != sum values");
        for (uint256 index = 0; index < addresses.length; index++) {
            //  require(
            //         creatorAddresses[index].length ==
            //             creatorRates[index].length,
            //         "hash is error"
            //     );
            if (types[index] == 2) {
                emit Buy(
                    addresses[index],
                    types[index],
                    tokenIds[index],
                    froms[index],
                    tos[index],
                    amounts[index],
                    values[index]
                );
                string memory s = bytesToHex(
                    bytes.concat(
                        keccak256(
                            abi.encodePacked(
                                __salt,
                                orderIds[index],
                                uint2str(msg.value)
                            )
                        )
                    )
                );
                require(
                    keccak256(abi.encodePacked(s)) ==
                        keccak256(abi.encodePacked(orderHashs[index])),
                    "hash is error"
                );

                if (
                    keccak256(
                        abi.encodePacked(
                            IErc1155(addresses[index]).uri(tokenIds[index])
                        )
                    ) == keccak256("")
                ) {
                    IErc1155(addresses[index]).mint(
                        tos[index],
                        tokenIds[index],
                        names[index],
                        tokenURIs[index],
                        amounts[index]
                    );
                } else if (
                    IErc1155(addresses[index]).balanceOf(
                        froms[index],
                        tokenIds[index]
                    ) < amounts[index]
                ) {
                    uint256 b = IErc1155(addresses[index]).balanceOf(
                        froms[index],
                        tokenIds[index]
                    );
                    IErc1155(addresses[index]).mint(
                        tos[index],
                        tokenIds[index],
                        names[index],
                        tokenURIs[index],
                        amounts[index] - b
                    );
                }
                uint256 _value = msg.value;
                // for (uint256 i = 0; i < creatorAddresses[i].length; i++) {
                //     address payable user = payable(creatorAddresses[index][i]);
                //     uint256 currentValue = (creatorRates[index][i] *
                //         msg.value) / 100;
                //     user.transfer(currentValue);
                //     _value = _value - currentValue;
                //     emit Creator(user, creatorRates[index][i]);
                // }
                IErc1155(addresses[index]).safeTransferFrom(
                    froms[index],
                    tos[index],
                    tokenIds[index],
                    amounts[index],
                    ""
                );
                address payable o = payable(froms[index]);
                o.transfer(_value);
            } else if (types[index] == 1) {
                // function ownerOf(uint256 tokenId) external view returns (address owner);
                address payable from = payable(IErc721(addresses[index]).ownerOf(
                    tokenIds[index]
                ));
                emit Buy(
                    addresses[index],
                    types[index],
                    tokenIds[index],
                    from,
                    tos[index],
                    1,
                    values[index]
                );

                require(sell721List[tokenIds[index]] != 0, "Item not selling");
                require(msg.value == sell721List[tokenIds[index]], "Incorrect price");
                emit CancelSell(tokenIds[index], 2);
                delete sell721List[tokenIds[index]];
                IErc721(addresses[index]).safeTransferFrom(IErc721(addresses[index]).ownerOf(tokenIds[index]), tos[index], tokenIds[index]);
                uint256 _value = msg.value;
                // for (uint256 i = 0; i < creatorAddresses[index].length; i++) {
                //     address payable user = payable(creatorAddresses[index][i]);
                //     uint256 currentValue = (creatorRates[index][i] * msg.value) / 100;
                //     user.transfer(currentValue);
                //     _value = _value - currentValue;
                //     emit Creator(user, creatorRates[index][i]);
                // }
                from.transfer(_value);
            }
        }
    }
}
