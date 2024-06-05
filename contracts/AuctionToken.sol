// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

import { ERC721 } from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";

// when your're back, merge this contract with the auction contract

contract AuctionToken is ERC721, Ownable {
    uint public contant MAX_SUPPLY = 1000;
    uint public immutable TOTAL_SUPPLY;
    uint public immutable maxMintPerWallet;
    
    constructor() ERC721("Arewa Auction", "AAN") Ownable(msg.sender) {}

    function Mint(uint qtty) external {
        require((TOTAL_SUPPLY + qtty) < MAX_SUPPLY, "Mint amount exceeds max supply");
        require(balanceOf(msg.sender) + qtty < maxMintPerWallet, "Max allowed mint exceeded");

        for(uit i = 0; i < qtty; i++){
            _mint(msg.sender, TOTAL_SUPPLY + 1);
            TOTAL_SUPPLY ++;
        }
    }

    function safeMint (address to) external payable() {
        require(to != address(0), "Invalid receipient wallet");
        require(msg.value <= price(), "Invalid ether amount");
        
        TOTAL_SUPPLY++;
        uint tokenId = TOTAL_SUPPLY;
        _safeMint(to, tokenId)
    }
}