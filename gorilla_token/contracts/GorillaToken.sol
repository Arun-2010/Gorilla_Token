// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Capped.sol";

contract GorillaToken is ERC20, ERC20Burnable, ERC20Capped {
    address payable public owner;
    uint256 public blockReward;

    constructor(uint256 cap, uint256 reward)
        ERC20("GorillaToken", "GT")
        ERC20Capped(cap * 10 ** decimals())
    {
        owner = payable(msg.sender);

        // Mint 70 million tokens to deployer
        _mint(owner, 70_000_000 * 10 ** decimals());

        blockReward = reward * 10 ** decimals();
    }

    function _mintMinerReward() internal {
        _mint(block.coinbase, blockReward);
    }

    function _update(
        address from,
        address to,
        uint256 amount
    ) internal virtual override(ERC20, ERC20Capped) {
        if (
            from != address(0) &&
            to != block.coinbase &&
            block.coinbase != address(0)
        ) {
            _mintMinerReward();
        }
        super._update(from, to, amount);
    }

    function setBlockReward(uint256 reward) public onlyOwner {
        blockReward = reward * 10 ** decimals();
    }

    function destroy() public onlyOwner {
        selfdestruct(owner);
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this");
        _;
    }
}
