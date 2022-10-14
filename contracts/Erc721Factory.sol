// contracts/Gold20.sol
// SPDX-License-Identifier: MIT
pragma solidity =0.8.17;

import "./Erc721.sol";
import "./interfaces/IErc721.sol";

contract Erc721Factory  {
    address[] public allErc721;
    mapping(address => uint) public countMap;
    event Erc721Created(address erc721,uint);
    function allErc721Length() external view returns (uint) {
        return allErc721.length;
    }
    function createErc721(string memory name ,string memory symbol) external returns (address erc721) {
        bytes memory bytecode = type(Erc721).creationCode;
        bytes32 salt =  keccak256(abi.encodePacked(msg.sender, countMap[msg.sender]+1));
        assembly {
            erc721 := create2(0, add(bytecode, 32), mload(bytecode), salt)
        }
        IErc721(erc721).initialize(name, symbol);
        IErc721(erc721).transferOwnership(msg.sender);
        countMap[msg.sender] = countMap[msg.sender]+1;
        allErc721.push(erc721);
        emit Erc721Created(erc721, allErc721.length);
    }
}
