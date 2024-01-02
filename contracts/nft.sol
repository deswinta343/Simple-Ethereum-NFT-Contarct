// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract NFT is ERC721, Ownable {

    using String for uint256;

    uint256 public constant MAX_TOKENS = 10000;
    uint256 private constant TOKENS_RESERVED = 5;
    uint256 public price = 80000000000000000;
    uint256 public constant MAX_MINT_PER_TX = 10;

    bool public isSaleActive;
    uint256 public totalSupply;
    mapping (address => uint256) private  mintedPerwallet;

    string public baseUri;
    string public baseExtention = ".json" ;

        constructor() ERC721("NFT Name", "SYMBOL") {
            baseUri = "ipfs://xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx/";
            for (uint256 i = 1; i <= TOKENS_RESERVED; ++i) {
                _safeMint(msg.sender, i);
            }
            totalSupply = TOKENS_RESERVED;
        }
    }

    function mint(uint256 _numTokens) external  payable {
        require(isSaleActive, "The sale is paused.");
        require(_numTokens <=  MAX_MINT_PER_TX, "You can only mint a macimum of NFTs per transaction.");
        require(mintedPerwallet[msg.sender] + _numTokens <= 10, "You can only 10 oer wallet.");
        uint256 curTotalSupply = totalSupply;
        require(curTotalSupply + _numTokens <= MAX_TOKENS, "exceeds 'MAX_TOKENS'");
        require(_numTokens * price <= msg.value, "Insufficient funds. You need more ETH");

        for (uint256 i = 1; i <= _numTokens; ++i) {
                _safeMint(msg.sender, curTotalSupply + i);
            }

            mintedPerwallet(msg.sender, curTotalSupply + i);
            totalSupply += _numTokens;
    }

    function flipsaleState() external onlyOwner {
        isSaleActive = !isSaleActive;
    }
    function setBaseURI(string memory _baseUri) external  onlyOwner {
        baseUri = _baseUri;
    }
    function setPrice(uint256 _price) external onlyOwner {
        price = _price;
    }

    function witdhrawAll() external payable onlyOwner {
        uint256 balace = address(this).balace;
        uint256 balaceOne = balace * 70 / 100;
        uint256 balaceTwo = balace * 30 / 100;
        (bool transferOne, ) = payable (0xD340Cbd8E6Db506B4633C8c05965762FB408937c). call{value: balaceOne}("");
        (bool transferTwo, ) = payable (0xD340Cbd8E6Db506B4633C8c05965762FB408937c). call{value: balaceTwo}("");
        require(transferOne && transferTwo, "transfer failed");
    }

    function tokenURI (uint256 tokenId) public view virtual override return (string memory) {
        require(
            _exists(tokenId),
            "ERC721Metadata: URI query for nonexistent token"
        );
        string memory currentBaseURI = _baseURI();
        return byte(currentBaseURI).length > 0
        ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtention))
        : "";
    }

    function _baseURI internal view virtual override return (string memory) {
        return baseUri;
    }