// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;


import { ERC721 } from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";

contract DutchAuction is ERC721, Ownable {
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
    uint public constant MAXMINT_PER_WALLET = 10;


    mapping(address => uint) private _balances;
    mapping(uint => address) private _tokenApprovals;
    mapping(address => mapping(address => bool)) private _allTokensApprovals;



// AUCTION STATE VARIABLES
    address payable treasury;

    struct AuctionMint {
        uint tokenId;
        address wallet;
        uint mintCost;
    }

    mapping(uint => AuctionMint) public auctionMints;





    // MODIFIERS
    modifier belowMaxSupply () {
        require(totalSupply + 1 < MAXSUPPLY, "Max supply reached");
        _;
    }
    

    constructor() ERC721("Dutch Auction", "DAUN") Ownable(msg.sender){
        startAuction = block.timestamp;     
        endAuction = startAuction + DURATION;
    }

    function price () public view returns (uint){
        // require(block.timestamp < endAuction, "Auction has ended"); // if ends, return default least price
        if(endAuction < block.timestamp){
            return ENDPRICE;
        }

        uint timeElapsed = (block.timestamp - startAuction)/60;

        return STARTPRICE - (timeElapsed * DISCOUNTRATE);
    }
    
    function safeMint(uint amount) public belowMaxSupply() payable{
        require(amount + balanceOf(msg.sender) <= MAXMINT_PER_WALLET, "Max mint allowed per wallet is 10");
        uint mintCost = price();
        require(msg.value >= mintCost * amount, "Invalid ether value sent");

        for(uint i; i < amount; i++){
            totalSupply ++;

            auctionMints[totalSupply] = AuctionMint(totalSupply, msg.sender, mintCost);

            _safeMint(msg.sender, totalSupply);
        }

        _balances[msg.sender] += amount;

    }

    function withdraw () public payable onlyOwner(){
        require(address(this).balance > 0, "No token in contract");
        
        payable(owner()).transfer(address(this).balance);
    }

    function checkContractBalance () public onlyOwner() view returns (uint) {
        return address(this).balance;
    }



    // IMPLEMENTATION OF THE ERC721 INTERFACE

    function balanceOf(address wallet) public view virtual override returns (uint){
        uint tokensInWallet = _balances[wallet];
        return tokensInWallet;
    }

    function ownerOf(uint tokenIndex) public view virtual override returns (address){
        return _ownerOf(tokenIndex);
    }

    function safeTransferFrom(address to, uint tokenId) public {
        require(_ownerOf(tokenId) == msg.sender || _allTokensApprovals[msg.sender][msg.sender] || _tokenApprovals[tokenId] == msg.sender, "ERC721: transfer caller is not owner or approved");
        _safeTransfer(msg.sender, to, tokenId);
        emit Transfer(msg.sender, to, tokenId);
    }

    // function safeTransferFrom(address from, address to, uint tokenId) public virtual override {
    //     require(_ownerOf(tokenId) == msg.sender || _allTokensApprovals[msg.sender][from] || _tokenApprovals[tokenId] == msg.sender, "ERC721: transfer caller is not owner or approved");
    //     super._safeTransfer(from, to, tokenId);
    //     emit Transfer(from, to, tokenId);
    // }

    function transferFrom (address to, uint tokenId) public {
        require(_ownerOf(tokenId) == msg.sender || _allTokensApprovals[msg.sender][msg.sender] || _tokenApprovals[tokenId] == msg.sender, "ERC721: transfer caller is not owner or approved");
        _transfer(msg.sender, to, tokenId);
        emit Transfer(msg.sender, to, tokenId);
    }
    
    function approve(address to, uint tokenId) public virtual override {
        require(msg.sender != address(0), "Cannot allow spendng from a dead wallet");
        require(ownerOf(tokenId) == msg.sender, "Unauthorized");
        _approve(to, tokenId, msg.sender);
        _tokenApprovals[tokenId] = to;
        emit Approval(msg.sender, to, tokenId);
    }

    function getApproved(uint tokenId) public view virtual override returns (address) {
        require(tokenId < MAXSUPPLY, "Token Id does not exist");
        return _tokenApprovals[tokenId];
        
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
   
}