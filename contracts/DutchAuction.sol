// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

import { IDutchAuction } from "./IDutchAuction.sol";
import { ERC721 } from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import { ERC721Pausable } from "@openzeppelin/contracts/token/ERC721/extensions/ERC721Pausable.sol";

contract DutchAuction is ERC721, ERC721Pausable {
// ERC 721 STATE VARIABLES
    
    uint public startAuction;
    uint public endAuction;
    uint public intervals;
    uint public totalSupply;

    uint public constant STARTPRICE = 5 ether;
    uint public constant DURATION = 75 minutes;
    uint public constant ENDPRICE = 2 ether;
    uint public constant DISCOUNTRATE = 0.0025 ether;
    uint public constant MAXSUPPLY = 10000;


    mapping(address => uint) private _balances;
    mapping(uint => address) private _tokenApprovals;
    mapping(address => mapping(address => bool)) private _allTokensApprovals;




// AUCTION STATE VARIABLES
    address payable treasury;

    enum BidStatus {
        ACCEPTED,
        REJECTED,
        PENDING
    }

    struct Bid {
        uint tokenIndex;
        address bidder;
        uint bidAmount;
        BidStatus status;
    }
    
    mapping(uint => mapping(address => Bid)) public bids;
    
    Bid public winningBid;




    

    constructor() ERC721("Dutch Auction", "DAUN"){
        startAuction = block.timestamp;
        endAuction = startAuction + DURATION;
    }

    function price () public view returns (uint){
        require(block.timestamp < endAuction, "Auction has ended");

        uint timeElapsed = (block.timestamp - startAuction)/60;

        return STARTPRICE - (timeElapsed * DISCOUNTRATE);
    }
    




    // IMPLEMENTATION OF THE ERC721 INTERFACE

    function balanceOf(address wallet) public view virtual override returns (uint){
        uint tokensInWallet = _balances[wallet];
        return tokensInWallet;
    }

    function ownerOf(uint tokenIndex) public view virtual override returns (address){
        return _ownerOf(tokenIndex);
    }

    function safeTransferFrom(address from, address to, uint tokenId) public virtual override{
        require(_ownerOf(tokenId) == msg.sender || _allTokensApprovals[msg.sender][from] || _tokenApprovals[tokenId] == msg.sender, "ERC721: transfer caller is not owner or approved");
        _safeTransfer(from, to, tokenId);
        emit Transfer(from, to, tokenId);
    }

    function safeTransferFrom(address from, address to, uint tokenId, bytes memory data) public virtual override  {
        require(_ownerOf(tokenId) == msg.sender || _allTokensApprovals[msg.sender][from] || _tokenApprovals[tokenId] == msg.sender, "ERC721: transfer caller is not owner or approved");
        _safeTransfer(from, to, tokenId, data);
        emit Transfer(from, to, tokenId);
    }
        function transferFrom (address from, address to, uint tokenId) public virtual override {
        require(_ownerOf(tokenId) == msg.sender || _allTokensApprovals[msg.sender][from] || _tokenApprovals[tokenId] == msg.sender, "ERC721: transfer caller is not owner or approved");
        _transfer(from, to, tokenId);
        emit Transfer(from, to, tokenId);
    }
    
    function approve(address to, uint tokenId) public virtual override {
        require(to != address(0), "Cannot allow spendng from a dead wallet");
        _approve(to, tokenId, msg.sender);
        emit Approval(msg.sender, to, tokenId);
    }

    function getApproved(uint tokenId) public view virtual override returns (address spender) {
        require(tokenId < MAXSUPPLY, "Token Id does not exist");
        _tokenApprovals[tokenId];
    }

    function setApprovalForAll(address operator, bool _approved) public virtual override{
        require (operator != address(0), "Cannot approve dead account");
        _allTokensApprovals[msg.sender][operator] = _approved;
    }   

    function isApprovedForAll(address owner, address operator) public view virtual override returns (bool){
        require(owner != address(0), "Dead wallet");
        bool allowed = _allTokensApprovals[owner][operator];
        return allowed;        
    }


    // internal functions for the ERC721 CONTRACT

    function _update(address to, uint tokenId, address auth) internal virtual override(ERC721, ERC721Pausable) returns (address) {
        super._update(to, tokenId, auth);
        emit Transfer(msg.sender, to, tokenId);
    }
    

    // IMPLEMENTATION OF THE DUTCH CONTRACT FUNCTIONS
    
}