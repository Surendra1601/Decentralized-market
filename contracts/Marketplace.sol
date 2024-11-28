// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Marketplace {
    struct Item {
        uint id;
        string name;
        uint priceInEth;
        address payable seller;
        address buyer;
        bool sold;
    }

    uint public itemCount;
    mapping(uint => Item) public items;

    event ItemListed(uint id, string name, uint priceInEth, address seller);
    event ItemPurchased(uint id, address buyer, uint priceInEth);

    // List an item for sale
    function listItem(string memory _name, uint _priceInEth) public {
        require(_priceInEth > 0, "Price must be greater than 0 Ether");
        itemCount++;
        items[itemCount] = Item(itemCount, _name, _priceInEth, payable(msg.sender), address(0), false);
        emit ItemListed(itemCount, _name, _priceInEth, msg.sender);
    }

    // Buy a listed item
    function buyItem(uint _id) public payable {
        Item storage item = items[_id];
        require(item.id > 0 && item.id <= itemCount, "Item does not exist");
        require(!item.sold, "Item already sold");
        require(msg.value == item.priceInEth * 1 ether, "Incorrect payment amount");
        require(msg.sender != item.seller, "Seller cannot buy their own item");

        item.buyer = msg.sender;
        item.sold = true;
        item.seller.transfer(item.priceInEth * 1 ether);

        emit ItemPurchased(item.id, msg.sender, item.priceInEth);
    }
}
