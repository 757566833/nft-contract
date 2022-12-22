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
    },
    arbitrumGoerli:{
      url: "https://arb-goerli.g.alchemy.com/v2/kxvi6SHAw1RR1Mn4PFuDb1EJhV5nHU07",
      accounts: ['59c6995e998f97a5a0044966f0945389dc9e86dae88c7a8412f4603b6b78690d'],
      gas: 'auto',
      gasPrice: 'auto'
    },
    optimismGoerli:{
      url: "https://goerli.optimism.io",
      accounts: ['0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80'],
      gas: 'auto',
      gasPrice: 'auto'
    },
    arbitrumOne:{
      url: "https://arb1.arbitrum.io/rpc",
      accounts: ['0ab5a3e7d8466e0bce128889984011bc1df639df30039da5cc78824a4c302e33'],
      gas: 'auto',
      gasPrice: 'auto'
    },
  }
};

export default config;
