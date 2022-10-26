// contracts/Gold20.sol
// SPDX-License-Identifier: MIT
pragma solidity =0.8.17;

import "./Erc721.sol";
import "./interfaces/IErc721.sol";

contract Erc721Factory {
    using Counters for Counters.Counter;
    Counters.Counter private _count;
    event Created(address indexed sender,address indexed erc721);

    function createErc721(string memory name, string memory symbol)
        external
        returns (address erc721)
    {
        bytes memory bytecode = type(Erc721).creationCode;
        _count.increment();
        bytes32 salt = keccak256(
            abi.encodePacked(msg.sender,_count.current())
        );
        assembly {
            erc721 := create2(0, add(bytecode, 32), mload(bytecode), salt)
        }
        IErc721(erc721).initialize(name, symbol);
        IErc721(erc721).transferOwnership(msg.sender);
        emit Created(msg.sender,erc721);
    }
}
