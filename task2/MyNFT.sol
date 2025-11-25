// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract MyNFT is ERC721URIStorage {

    uint private _tokenId;

    constructor(string memory name_, string memory symbol_) ERC721(name_, symbol_) {}

    function mintNFT(address to, string memory _tokenURI) external {
        _tokenId++;
        _mint(to, _tokenId);
        _setTokenURI(_tokenId, _tokenURI);
    }
    
}