
// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol" ;
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Capped.sol";


contract GorillaToken is ERC20Capped, ERC20Burnable {
    address  payable public owner;
    uint256 public blockReward;
    constructor(uint256 cap,uint256 reward) ERC20("gorillatoken","GT") ERC20Capped(cap * 10 ** decimals()) {
        owner = payable(msg.sender);
        // Initial supply of 70 million tokens to the contract deployer(in this case, the owner)
        _mint(owner, 70000000 * 10 ** decimals());
        blockReward = reward * 10 ** decimals();
    }

    function _mintminerReward() internal {
        _mint(block.coinbase, blockReward);
    }

    function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override {
        if (from != address(0) && to != block.coinbase && block.coinbase != address(0)) {
            _mintminerReward();
        }
        super._beforeTokenTransfer(from, to, amount);
    }


    function setblockreward(uint256 reward) public onlyOwner {
        blockReward = reward * 10 ** decimals();
    }


        function destroy() public onlyOwner {
        selfdestruct(owner);
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }


}



