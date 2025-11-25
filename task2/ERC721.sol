// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC165 {
    function supportsInterface(bytes4 interfaceId) external view returns (bool);
}

interface IERC721Receiver {
    function onERC721Received(
        address operator,
        address from,
        uint256 tokenId,
        bytes calldata data
    ) external returns (bytes4);
}

interface IERC721 is IERC165 {
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);

    function balanceOf(address owner) external view returns (uint256 balance);
    function ownerOf(uint256 tokenId) external view returns (address owner);
    function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
    function safeTransferFrom(address from, address to, uint256 tokenId) external;
    function transferFrom(address from, address to, uint256 tokenId) external;
    function approve(address to, uint256 tokenId) external;
    function setApprovalForAll(address operator, bool approved) external;
    function getApproved(uint256 tokenId) external view returns (address operator);
    function isApprovedForAll(address owner, address operator) external view returns (bool);
}

contract ERC721 is IERC165, IERC721 {
    string public name;
    string public symbol;

    constructor(string memory _name, string memory _symbol) {
        name = _name;
        symbol = _symbol;
    }

    mapping(uint => address) _owners;
    mapping(address => uint) _balances;
    mapping(uint => address) _tokenApprovals;
    mapping(address => mapping(address => bool)) _operatorApprovals;

    function supportsInterface(bytes4 interfaceId) external view returns (bool) {
        return interfaceId == type(IERC165).interfaceId || interfaceId == type(IERC721).interfaceId;
    }

    function balanceOf(address owner) external view returns (uint256 balance) {
        require(owner != address(0), "owner = address 0");
        return _balances[owner];
    }

    function ownerOf(uint256 tokenId) external view returns (address owner) {
        owner = _owners[tokenId];
        require(owner != address(0), "owner = address 0");
    }

    function setApprovalForAll(address operator, bool approved) external {
        _operatorApprovals[msg.sender][operator] = approved;
        emit ApprovalForAll(msg.sender, operator, approved);
    }

    function approve(address to, uint256 tokenId) external {
        address owner = _owners[tokenId];
        require(msg.sender == owner || _operatorApprovals[owner][msg.sender], "not authorized");
        _tokenApprovals[tokenId] = to;
        emit Approval(owner, to, tokenId);
    }

    function getApproved(uint256 tokenId) external view returns (address operator) {
        require(_owners[tokenId] != address(0), "token not exist");
        return _tokenApprovals[tokenId];
    }

    function isAuthorized(address owner, address spender, uint tokenId) internal view returns (bool) {
        return (owner == spender || _operatorApprovals[owner][spender] || spender == _tokenApprovals[tokenId]);
    }

    function transferFrom(address from, address to, uint256 tokenId) public {
        require(from == _owners[tokenId], "not owner");
        require(to != address(0), "to = address 0");
        require(isAuthorized(from, msg.sender, tokenId), "not authorized");

        _balances[from] -= 1;
        _balances[to] += 1;

        _owners[tokenId] = to;
        delete _tokenApprovals[tokenId];

        emit Transfer(from, to, tokenId);
    }

    function safeTransferFrom(address from, address to, uint256 tokenId) external {
        transferFrom(from, to, tokenId);

        require(
            to.code.length == 0 ||
                IERC721Receiver(to).onERC721Received(msg.sender, from, tokenId, "") ==
                    IERC721Receiver.onERC721Received.selector,
            "unsafe transfer"
        );
    }

    function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external {
        transferFrom(from, to, tokenId);

        require(
            to.code.length == 0 ||
                IERC721Receiver(to).onERC721Received(msg.sender, from, tokenId, data) ==
                    IERC721Receiver.onERC721Received.selector,
            "unsafe transfer"
        );
    }

    function isApprovedForAll(address owner, address operator) external view returns (bool) {
        return _operatorApprovals[owner][operator];
    }

    function _mint(address to, uint tokenId) internal {
        require(to != address(0), "to = address 0");
        require(_owners[tokenId] == address(0), "token exists");

        _owners[tokenId] = to;
        _balances[to] += 1;

        emit Transfer(address(0), to, tokenId);
    }

    function _burn(uint tokenId) internal {
        address owner = _owners[tokenId];
        require(owner != address(0), "token not exists");

        _balances[owner] -= 1;
        delete _owners[tokenId];
        delete _tokenApprovals[tokenId];

        emit Transfer(owner, address(0), tokenId);
    }
}
