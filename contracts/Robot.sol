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
        uint256 indexed tokenId,
        uint256 indexed price
    );

    constructor(
        string memory _versoion

    ) {
        __version = _versoion;
    }

    function version() public view returns (string memory) {
        return __version;
    }

    function batchMint1155(
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
        string[] memory types,
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
                (names.length == values.length)
        );
        uint256 _total = 0;
        for (uint256 index = 0; index < values.length; index++) {
            _total += values[index];
        }
        require(_total == msg.value, "value != sum values");
        for (uint256 index = 0; index < addresses.length; index++) {
            if (
                (keccak256(abi.encodePacked(types[index]))) ==
                keccak256("1155")
            ) {
                {
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
                }
            } else if (
                (keccak256(abi.encodePacked(types[index]))) ==
                keccak256("721")
            ) {
                {
                    IErc721(addresses[index]).buy{value: msg.value}(
                        tokenIds[index],
                        tos[index]
                        // creatorAddress,
                        // creatorRate
                    );
                }
            }
        }
    }
}
