// SPDX-License-Identifier: UNLICENSED
pragma solidity =0.8.17;

// Uncomment this line to use console.log
// import "hardhat/console.sol";
import "./interfaces/IErc721.sol";
import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155URIStorage.sol";
import "./interfaces/IErc1155.sol";

contract Robot {
    string private __version;
    event Buy(
        address indexed contractAddress,
        uint256 indexed cType,
        uint256 indexed tokenId,
        address from,
        address to,
        uint256 amount,
        uint256 price
    );

    event Lock(
        address indexed contractAddress,
        string indexed name,
        string indexed tokenURI,
        address to,
        uint256 tokenId,
        uint256 amount
    );

    constructor(string memory _versoion) {
        __version = _versoion;
    }

    function version() public view returns (string memory) {
        return __version;
    }

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
                (tokenURIs.length == names.length)
        );
        for (uint256 index = 0; index < tos.length; index++) {
            emit Lock(
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
                (names.length == values.length),
            "length not same"
        );
        uint256 _total = 0;
        for (uint256 index = 0; index < values.length; index++) {
            _total += values[index];
        }
        require(_total == msg.value, "value != sum values");
        for (uint256 index = 0; index < addresses.length; index++) {
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
                IErc1155(addresses[index]).buy{value: values[index]}(
                    orderIds[index],
                    orderHashs[index],
                    froms[index],
                    tos[index],
                    tokenIds[index],
                    amounts[index],
                    tokenURIs[index],
                    names[index]
                    // creatorAddress,
                    // creatorRate
                );
            } else if (types[index] == 1) {
                // function ownerOf(uint256 tokenId) external view returns (address owner);
                address from = IErc721(addresses[index]).ownerOfTokenId(
                    tokenIds[index]
                );
                emit Buy(
                    addresses[index],
                    types[index],
                    tokenIds[index],
                    from,
                    tos[index],
                    1,
                    values[index]
                );
                IErc721(addresses[index]).buy{value: values[index]}(
                    tokenIds[index],
                    tos[index]
                    // creatorAddress,
                    // creatorRate
                );
            }
        }
    }
}
