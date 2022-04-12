pragma solidity >=0.8.0 <0.9.0;
//SPDX-License-Identifier: MIT

import 'hardhat/console.sol';
import './ExampleExternalContract.sol';

import "hardhat/console.sol";
import "./ExampleExternalContract.sol";

contract Staker {

  mapping( address => uint256 ) public balances;

  uint256 public constant threshold = 1 ether;
  uint256 public deadline = block.timestamp + 72 hours;
  bool public openForWithdraw = false;

  event Stake(address user, uint256 amount);

  ExampleExternalContract public exampleExternalContract;

  constructor(address exampleExternalContractAddress) public {
      exampleExternalContract = ExampleExternalContract(exampleExternalContractAddress);
  }

  // Collect funds in a payable `stake()` function and track individual `balances` with a mapping:
  //  ( make sure to add a `Stake(address,uint256)` event and emit it for the frontend <List/> display )
  function stake() payable public {
    require(block.timestamp <= deadline, "Staking period is over!");
    balances[msg.sender] = balances[msg.sender] + msg.value;
    emit Stake(msg.sender, msg.value);
  }

  // After some `deadline` allow anyone to call an `execute()` function
  //  It should either call `exampleExternalContract.complete{value: address(this).balance}()` to send all the value
  function execute() public notCompleted{
    require(block.timestamp > deadline, "Staking period is not over yet.");
    if (address(this).balance >= threshold){
      exampleExternalContract.complete{value: address(this).balance}();
    }else{
      openForWithdraw = true;
    }
  }

  function withdraw() public notCompleted{
    require(openForWithdraw);
   
    payable(msg.sender).transfer(balances[msg.sender]);
    balances[msg.sender] = 0;
  }

  function timeLeft() public view returns(uint256){
    if (block.timestamp >= deadline){
      return 0;
    }else{
      return (deadline - block.timestamp);
    }
  }

  modifier notCompleted(){
		require(!exampleExternalContract.completed(), "already completed!");
		_;
	}

  receive() external payable{
    stake();
  }
  // if the `threshold` was not met, allow everyone to call a `withdraw()` function


  // Add a `withdraw()` function to let users withdraw their balance


  // Add a `timeLeft()` view function that returns the time left before the deadline for the frontend


  // Add the `receive()` special function that receives eth and calls stake()


}
