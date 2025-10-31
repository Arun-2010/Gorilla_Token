
// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";


contract GorillaToken is ERC20{
    address public owner;
    constructor() ERC20("gorillatoken","GT") {
        owner = msg.sender;
        // Initial supply of 70 million tokens to the contract deployer(in this case, the owner)
        _mint(owner, 70000000 * 10 ** decimals());
    }



}



