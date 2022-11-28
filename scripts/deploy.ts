import { ethers } from "hardhat";
import dotenv from 'dotenv'
dotenv.config();
async function main() {
  // const currentTimestampInSeconds = Math.round(Date.now() / 1000);
  // const ONE_YEAR_IN_SECS = 365 * 24 * 60 * 60;
  // const unlockTime = currentTimestampInSeconds + ONE_YEAR_IN_SECS;

  // const lockedAmount = ethers.utils.parseEther("1");

  // const Lock = await ethers.getContractFactory("Lock");
  // const lock = await Lock.deploy(unlockTime, { value: lockedAmount });

  // await lock.deployed();

  // console.log(`Lock with 1 ETH and unlock timestamp ${unlockTime} deployed to ${lock.address}`);

  const Robot = await ethers.getContractFactory("Robot");
  const robot = await Robot.deploy(process.env.ROBOT_VERSION||'',process.env.ERC1155_SALT||'');

  await robot.deployed();

  console.log(`robot deployed to ${robot.address}`);

  const Erc721Factory = await ethers.getContractFactory("Erc721Factory");
  const erc721Factory = await Erc721Factory.deploy(process.env.FACTORY_VERSION||'',robot.address);

  await erc721Factory.deployed();

  console.log(`erc721Factory deployed to ${erc721Factory.address}`);



  const Erc1155 = await ethers.getContractFactory("Erc1155");
  const erc1155 = await Erc1155.deploy(process.env.ERC1155_VERSION||'',robot.address,);

  await erc1155.deployed();

  console.log(`erc1155 deployed to ${erc1155.address}`);

}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
