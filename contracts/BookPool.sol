// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract BookRegistry {
    struct Book {
        string title;
        string author;
        string cid; // IPFS CID
        address uploader;
        uint256 timestamp;
    }

    mapping(string => Book) public books;
    string[] public bookList;

    event BookRegistered(string cid, string title, string author, address uploader, uint256 timestamp);

    function registerBook(string memory _title, string memory _author, string memory _cid) public {
        require(bytes(books[_cid].cid).length == 0, "Book already registered");

        books[_cid] = Book({
            title: _title,
            author: _author,
            cid: _cid,
            uploader: msg.sender,
            timestamp: block.timestamp
        });

        bookList.push(_cid);

        emit BookRegistered(_cid, _title, _author, msg.sender, block.timestamp);
    }

    function getBook(string memory _cid) public view returns (Book memory) {
        return books[_cid];
    }

    function getAllBooks() public view returns (Book[] memory) {
        Book[] memory allBooks = new Book[](bookList.length);
        for (uint i = 0; i < bookList.length; i++) {
            allBooks[i] = books[bookList[i]];
        }
        return allBooks;
    }
}