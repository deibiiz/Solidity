// SPDX-License-Identifier: MIT

pragma solidity >=0.6.6 <0.9.0;

import "@chainlink/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol";
import "@chainlink/contracts/src/v0.6/vendor/SafeMathChainlink.sol";


contract FundMe {
    using SafeMathChainlink for uint256;

    mapping(address => uint256) public addressToAmountFunded;
    
    address[] public funders;

    address public  owner;

    constructor() public {
        owner = msg.sender;
    }


    function fund() public payable {
        uint256 minimunUSD = 50 * 10 **18; //establecer un minimo de 50 usd
        require(getConversionRate(msg.value) >= minimunUSD, "Necesitas gastar mas ethereum");
        addressToAmountFunded[msg.sender] += msg.value;
        funders.push(msg.sender);
    }

    function getVersion() public view returns (uint256) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        return priceFeed.version();
    }

    function getPrice() public view returns (uint256) { //nos muestra el precio actual
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        (,int price,,,) = priceFeed.latestRoundData();
        return uint256(price * 10000000000); //sepolia eth/usd tiene 8 decimales y wei 18 --> por lo tanto 10 ceros
    }

    function getConversionRate(uint256 ethAmout) public view returns(uint256){
        uint256 ethPrice = getPrice();
        uint256 ethAmoutInUsd = (ethPrice * ethAmout) / 1000000000000000000;
        return ethAmoutInUsd;
    }

    modifier onlyOwner{
        require(msg.sender == owner);
        _;
    }

    function withDraw() payable onlyOwner public{ 
        msg.sender.transfer(address(this).balance);
        for(uint256 funderIndex; funderIndex < funders.length; funderIndex++){
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;
        }

        funders = new address[](0); // vaciar el array
    }

}
