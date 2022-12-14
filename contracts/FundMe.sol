// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;

// To consume price data, your smart contract should reference AggregatorV3Interface, 
// which defines the external functions implemented by Data Feeds.
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract FundMe {
    uint256 public minimumUsd = 50 * 1e18;

    address[] public funders;
    mapping (address => uint256) public addressToAmountFunded; 

    function fund() public payable {
        require(getConversionRate(msg.value) >= minimumUsd, "Didn't send enough");
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] = msg.value;
    }

    function getPrice() public view returns(uint256) {
        // ABI
        // Address 0x0715A7794a1dc8e42615F059dD6e406A6594651A
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x0715A7794a1dc8e42615F059dD6e406A6594651A);
        (,int256 price,,,) = priceFeed.latestRoundData();
        // ETH in terms of USD
        // 3000.00000000
        return uint256(price * 1e10); // 1**10 == 10000000000
    }

    function getConversionRate(uint256 ethAmount) public view returns (uint256) {
        uint256 ethPrice = getPrice();
        // 3000_000000000000000000 = ETH / USD price
        // 1_000000000000000000 ETH

        uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1e18;
        // 3000 USD
        return ethAmountInUsd;
    }
}