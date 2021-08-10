pragma solidity >0.5.0;

// BigBang is the creator of the universe, He is owner of all grounds therefore all grounds are brought from him 

import "../openzeppelin/token/ERC721/extensions/ERC721Full.sol";
import "../openzeppelin/token/ERC721/extensions/IERC721Metadata.sol";
import "../openzeppelin/access/Ownable.sol";

contract BigBang is IERC721Metadata, ERC721Full, Ownable{

    struct ground { 
        uint id;
        string name;
        string description;
        string url;
        uint price;
        bool forSale;
        bool auctioning; 
    }

    ground[] public grounds;

    event listedForSale(uint indexed id, uint indexed price);
    event startedAuction(uint indexed id, uint indexed baseprice, uint time)
    //event endededAuction(uint indexed id, uint indexed highestBid, address highestBidder)

    mapping(string => bool) _groundExists;

    //mapping(uint => bool) _listedForAuction;
    mapping(uint => uint) public sellerPrices;

    struct auction { 
        uint tokenId
        uint price;
        uint endTime;
        }
    auction[] public auctions;

    // Grounds are reprensted by the symbol GND

    constructor() ERC721("GROUND", "GND") public {}

    // Whenever the mint function is called, a new ground is made available

    function mint(string memory _name, string memory _description, string memory _url, uint _price) public onlyOwner returns (uint){
        require(!_groundExists[_url], "Ground already exist!");
        uint _id = grounds.length - 1;

        grounds[_id] = (
        _id,
        _name,
        _description,
        _url,
        _price,
        false,
        false
        );
    
        _mint(msg.sender, _id);
        _groundExists[_url] = true;

        return _id;
    }

    function listForSale(uint _id, uint _price) public {
        require(isApprovedOrOwner(msg.sender, _id), "Only Ground owners can list a ground for sale!");
        require(grounds[_id].forSale == false, "Already listed for sale!");
        require(grounds[_id].auctioning == false, "This Ground is currently auctioning!");
    
        grounds[_id].forSale = true;
        sellerPrices[_id] = _price;
        emit listedForSale(_id, grounds[_id].price);

    }

    function unlistForSale(uint _id) public {
        require(isApprovedOrOwner(msg.sender, _id), "Only Ground owners can unlist a ground for sale!");
        require(grounds[_id].forSale == true, "This Ground is not listed for sale!");
        require(grounds[_id].auctioning == false, "This ground is currently auctioning!");
    
        grounds[_id].forSale = false;
        sellerPrices[_id] = 0;
        emit listedForSale(_id, grounds[_id].price);
    }

    function updateSalePrice(uint _id, uint _price) public returns (bool){
        require(ownerOf(_id) == msg.sender);
        sellerPrices[_id] = _price;
    }

    function listForAuction(uint _id, uint _baseprice, uint _days) public {
        require(isApprovedOrOwner(msg.sender, _id), "Only Ground owners can list ground for sale!");
        require(grounds[_id].auctioning == false, "Already listed for auctioning!");

        grounds[_id].forSale = false; // Unlist ground for sale first

        // Transer Ground to GroundAgent for auctioning

        grounds[_id].auctioning = true;
        uint _endtime = now + (_days * 1 days); // Converts days to seconds
        auctions.push(auction(_id, _baseprice, _endtime)); // Pushes to the auctions array
        emit startedAuction(_id, _baseprice, _days);
    }



//   function approveGROUND(address _to, uint _tokenId) public {
//     approve(_to, _tokenId);
//   }
  
//   function isApprovedOrOwner(address _address, uint _tokenId) public returns (bool){
//     return _isApprovedOrOwner(_address, _tokenId);
//   }

//   function updatePrice(uint _id, uint _price) public returns (bool){
//     require(ownerOf(_id) == msg.sender);
//     groundData[_id].price = _price;

//     return true;
//   }

//   function approveForSale(address _to, uint _tokenId, uint _price) public {
//     require(_listedForAuction[_tokenId] == false);
//     _listedForSale[_tokenId] = true;
//     updatePrice(_tokenId, _price);
//     approveGROUND(_to, _tokenId);
//   }

//   function approveForAuction(address _to, uint _tokenId, uint _price, uint _time) public {
//     require(_listedForSale[_tokenId] == false);
//     _listedForAuction[_tokenId] = true;
//     // updatePrice(_tokenId, _price);
//     approveNFT(_to, _tokenId);

//     auctionData memory ad;
//     ad.price = _price;
//     ad.time = _time;

//     tokenAuction[_tokenId] = ad;
//   }

//   function nftSold(uint _tokenId) public {
//     _listedForSale[_tokenId] = false;
//     _listedForAuction[_tokenId] = false;
//   }

}