// contracts/Gold20.sol
// SPDX-License-Identifier: MIT
pragma solidity =0.8.17;

import "./Erc721.sol";
import "./interfaces/IErc721.sol";

contract Erc721Factory {
    using Counters for Counters.Counter;
    Counters.Counter private _count;
    string private __version;

    constructor(string memory _versoion) {
        __version = _versoion;
    }

    event Created(address indexed erc721);

    function version() public view returns (string memory) {
        return __version;
    }

    function createErc721(
        string memory _name,
        string memory _symbol
    ) external returns (address erc721) {
        bytes memory bytecode = type(Erc721).creationCode;
        _count.increment();
        bytes32 salt = keccak256(
            abi.encodePacked(msg.sender, _count.current())
        );
        assembly {
            erc721 := create2(0, add(bytecode, 32), mload(bytecode), salt)
        }
        IErc721(erc721).initialize(_name, _symbol, __version);
        IErc721(erc721).transferContractOwnership(msg.sender);
        emit Created(erc721);
    }
}
