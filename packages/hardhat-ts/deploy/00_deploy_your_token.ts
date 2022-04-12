import { DeployFunction } from 'hardhat-deploy/types';
import { parseEther } from 'ethers/lib/utils';
import { HardhatRuntimeEnvironmentExtended } from 'helpers/types/hardhat-type-extensions';
import { ethers } from 'hardhat';

const func: DeployFunction = async (hre: HardhatRuntimeEnvironmentExtended) => {
  const { getNamedAccounts, deployments } = hre as any;
  const { deploy } = deployments;
  const { deployer } = await getNamedAccounts();
  await deploy('YourToken', {
    // Learn more about args here: https://www.npmjs.com/package/hardhat-deploy#deploymentsdeploy
    from: deployer,
    // args: ["Hello"],
    log: true,
  });
  console.log("Account: ", deployer);
  const yourToken = await ethers.getContract('YourToken', deployer);

  // const result = await yourToken.transfer("0x0C56c62ecf7Cd3965A57B5D9A7974EeE578714C3", ethers.utils.parseEther("1000"));

  // address you want to be the owner.
  // yourContract.transferOwnership(YOUR_ADDRESS_HERE);
};
export default func;
func.tags = ['YourToken'];

