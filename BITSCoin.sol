pragma solidity ^0.4.18;

contract BITSCoin {

	mapping (address => uint256) public balanceOf;

	string public name = "BITSCoin";
	string public symbol = "BITS";
    uint256 public lastHalving = now;
    uint public lastIncrease = now;
	uint256 public max_supply = 21000000000000;
    uint256 public unspent_supply = 0;
    uint256 public spendable_supply = 0;
    uint256 public circulating_supply = 0;
    uint256 public decimals = 6;
    uint256 public reward = 50000000;

    // Creating the constructor
    function BITSCoin() public {
    	lastHalving = now;
    }

    // Creating various events associated with the currency
    event Transfer (address indexed from, address indexed to, uint256 value);
    event Mint(address indexed from, uint256 value);


}