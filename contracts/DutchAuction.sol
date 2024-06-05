// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

import { IDutchAuction } from "./IDutchAuction.sol";

contract DutchAuction is IAuction {
    address payable treasury;

    
    uint startAuction;
    uint endAuction;
    uint intervals;

    uint public constant STARTPRICE = 5 ether;
    uint public constant DURATION = 75 minutes;
    uint public constant ENDPRICE = 2 ether;
    uint public constant DISCOUNTRATE = 0.0025 ether;

    constructor(){
        startAuction = block.timestamp();
        endAuction = startAuction + duration;
    }

    function price () public view returns (uint){
        require(block.timestamp() < endAuction, "Auction has ended");

        uint timeElapsed = (block.timestamp() - startAuction)/60;

        return STARTPRICE - (timeElapsed * discountRate);
    }
}