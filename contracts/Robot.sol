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

    constructor(string memory _versoion) {
        __version = _versoion;
    }

    function version() public view returns (string memory) {
        return __version;
    }

    function buy721(
        address c,
        address to,
        uint256 tokenId,
        address[] memory _creatorAddress,
        uint8[] memory _creatorRate
    ) external payable {
        require(
            _creatorAddress.length == _creatorRate.length,
            "creator address length not equal to creator reate length"
        );
        emit Buy(c, tokenId, msg.value);
        IErc721(c).buy{value: msg.value}(
            tokenId,
            to,
            _creatorAddress,
            _creatorRate
        );
    }

    function mint1155(
        address c,
        address to,
        uint256 tokenId,
        string memory name,
        string memory tokenURI,
        uint256 amount
    ) external payable {
        IErc1155(c).mint(to, tokenId, name, tokenURI, amount);
    }

    function buy1155(
        address c,
        string memory orderId,
        string memory orderHash,
        address from,
        address to,
        uint256 tokenId,
        uint256 amount,
        string memory tokenURI,
        string memory name,
        address[] memory creatorAddresses,
        uint8[] memory creatorRates
    ) external payable {
        IErc1155(c).buy{value: msg.value}(
            orderId,
            orderHash,
            from,
            to,
            tokenId,
            amount,
            tokenURI,
            name,
            creatorAddresses,
            creatorRates
        );
    }

    function batchBuy1155(
        address c,
        string[] memory orderIds,
        string[] memory orderHashs,
        address[] memory froms,
        address[] memory tos,
        uint256[] memory tokenIds,
        uint256[] memory amounts,
        string[] memory tokenURIs,
        string[] memory names,
        uint256[] memory values,
        address[][] memory creatorAddresses,
        uint8[][] memory creatorRates
    ) external payable {
        IErc1155(c).batchBuy{value: msg.value}(
            orderIds,
            orderHashs,
            froms,
            tos,
            tokenIds,
            amounts,
            tokenURIs,
            names,
            values,
            creatorAddresses,
            creatorRates
        );
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
        uint256[] memory values,
        address[][] memory creatorAddresses,
        uint8[][] memory creatorRates
    ) external payable {
        for (uint256 index = 0; index < addresses.length; index++) {
            address c = addresses[index];
            string memory orderId = orderIds[index];
            string memory orderHash = orderHashs[index];
            address from = froms[index];
            address to = tos[index];
            uint256 tokenId = tokenIds[index];
            uint256 amount = amounts[index];
            string memory tokenURI = tokenURIs[index];
            string memory name = names[index];
            uint256 value = values[index];
            address[] memory creatorAddress = creatorAddresses[index];
            uint8[]  memory creatorRate = creatorRates[index];
            if (
                (keccak256(abi.encodePacked(types[index]))) == keccak256("1155")
            ) {
                IErc1155(c).buy{value: value}(
                    orderId,
                    orderHash,
                    from,
                    to,
                    tokenId,
                    amount,
                    tokenURI,
                    name,
                    creatorAddress,
                    creatorRate
                );
            } else if (
                (keccak256(abi.encodePacked(types[index]))) == keccak256("721")
            ) {
                IErc721(c).buy{value: msg.value}(
                    tokenId,
                    to,
                    creatorAddress,
                    creatorRate
                );
            }
        }
    }

    // function mintAndBuy1155(
    //     address c,
    //     string memory orderId,
    //     string memory orderHash,
    //     uint256 tokenId,
    //     address from,
    //     address to,
    //     string memory name,
    //     string memory tokenURI,
    //     uint256 amount
    // ) external payable {
    //     IErc1155(c).mintAndBuy{value: msg.value}(
    //         orderId,
    //         orderHash,
    //         tokenId,
    //         from,
    //         to,
    //         name,
    //         tokenURI,
    //         amount
    //     );
    // }
}
