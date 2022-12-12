import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";

const config: HardhatUserConfig = {
  // solidity: "0.8.17",
  solidity: {
    compilers: [{
      version: "0.8.17",
      // todo 什么是 viaIR?
      settings: {
        viaIR: true,
        optimizer: { enabled: true },
      },
    }]
  },
  networks: {
    local: {
      url: "http://127.0.0.1:8545",
      accounts: [
        "0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80",
      ],
    },
    edges: {
      url: "https://bc.metamall.top/rpc",
      accounts: ['0xfab54cdd36268dc0e8e8d9647aed14d9e0985d16f137460a4097a0fc11429eb1'],
      gas: 'auto',
      gasPrice: 'auto'
    },
    fzcode: {
      url: "https://rpc.fzcode.com",
      accounts: ['0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80'],
      gas: 'auto',
      gasPrice: 'auto'
    }
  }
};

export default config;
