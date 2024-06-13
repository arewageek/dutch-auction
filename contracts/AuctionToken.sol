// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

// import { ERC721 } from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
// import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";

// import { IDutchAuction } from "./IDutchAuction.sol";

// // when your're back, merge this contract with the auction contract

// contract AuctionToken is IDutchAuction, Ownable, ERC721 {
    
//     Bid public bid;

//     mapping(uint => Bid) bids;

//     constructor () Ownable(msg.sender) ERC721("Arewa Auction", "AAN") {}

//     // CONTRACT REWRITE AFTER INTERFACE CHANGE
//     function balanceOf (address tokenInd) external view returns (uint) {
//         return balanceOf(tokenIndex);
//     }

//     function ownerOf(uint tokenId) external view returns (address) {
//         _ownerOf(tokenId);
//     }

//     function safeTransferFrom(address from, address to, uint tokenId) external;

//     function transferFrom(address from, address to, uint tokenId) external;

//     function approve(address to, uint tokenId) external;

//     function getApproved(uint tokenId) external view returns (address operator);

//     function setApprovalForAll(address operator, bool _approved) external;

//     function isApprovedForAll(address owner, address operator) external view returns (bool);

//     function safeTransferFrom(address from, address to, uint tokenId, bytes memory data) external;



//     // INTERNAL FUNCTIONS ACCESSIBLE ONLY THROUGH A CONTRACT
//     function _safeTransferFrom(from, to, tokenId, _data) internal {}

//     function _exists(tokenId) internal;

//     function _isApprovedOrOwner(spender, tokenId) internal;

//     function _safeMint(to, tokenId) internal;

//     function _safeMint(to, tokenId, _data) internal;

//     // function _mint(to, tokenId) internal;

//     function _burn(owner, tokenId) internal;

//     function _burn(tokenId) internal;

//     function _transferFrom(from, to, tokenId) internal;

//     function _checkOnERC721Received(from, to, tokenId, _data) internal;
// }