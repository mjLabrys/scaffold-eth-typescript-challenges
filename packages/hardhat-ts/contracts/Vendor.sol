pragma solidity >=0.8.0 <0.9.0;
// SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/access/Ownable.sol";
import './YourToken.sol';

contract Vendor is Ownable {
  YourToken public yourToken;
  uint256 public constant tokensPerEth = 100;

  // re-entrancy protection
  bool public Flag;

  event BuyTokens(
    address buyer,
    uint256 amountOfEth,
    uint256 amountOfTokens 
  );

  constructor(address tokenAddress) public {
    yourToken = YourToken(tokenAddress);
  }

  // create a payable buyTokens() function:
  function buyTokens() public payable{
    uint tokenAmount = msg.value * tokensPerEth;
    require(yourToken.balanceOf(address(this)) >= tokenAmount && !Flag);

    Flag = true;
    yourToken.transfer(msg.sender, tokenAmount);
    emit BuyTokens(msg.sender, msg.value, tokenAmount);
    Flag = false;
  }

  // create a withdraw() function that lets the owner withdraw ETH
  function withdraw() public onlyOwner{
   
    uint256 etherAmount = address(this).balance;

    payable(msg.sender).transfer(etherAmount);
  }

  // create a sellTokens() function:
  function sellTokens(uint256 _amount) public {
    require(yourToken.balanceOf(msg.sender) >= _amount);
    uint etherAmount = _amount / tokensPerEth;
    require(address(this).balance >= etherAmount);

    yourToken.transferFrom(msg.sender, address(this), _amount);
    payable(msg.sender).transfer(etherAmount);
  }
}
