pragma solidity ^0.4.18;

contract BITSCoin {

	mapping (address => uint256) public balanceOf;

	string public name = "BITSCoin";
	string public symbol = "BITS";
    uint256 public lastHalving = now;
    uint public lastIncrease = now;
	uint256 public max_supply = 42000000000000;
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

    //The updateAccount() method
    function updateAccount() internal returns (uint256){

    	if(now - lastHalving >= 2100000 minutes) {
    		reward /= 2;                              // Halving the record after every 210000 minutes
    	}

    	if (now - lastIncrease >= 150 seconds){
	        uint256 increaseAmount = ((now - lastIncrease) / 150 seconds) * reward;
	        spendable_supply += increaseAmount;
	        unspent_supply += increaseAmount;
	        lastIncrease = now;
      }

      //circulating_supply = spendable_supply - unspent_supply;
      return (spendable_supply - unspent_supply);
    }


    // Method for Transferring Coins
    function transfer(address _to, uint256 transfer_amount) public {
        require(balanceOf[msg.sender] >= transfer_amount);           // Check if the sender has enough coins
        require(balanceOf[_to] + transfer_amount >= balanceOf[_to]); // Check for overflows
        balanceOf[_to] += transfer_amount;                           // Add coins to the recipient
        balanceOf[msg.sender] -= transfer_amount;                    // Subtract coins from the sender
        updateAccount();

        Transfer(msg.sender, _to, transfer_amount);                  // Transfer Completed Notification
    }


    // Minting new coins by sending the currency - Ether
    function mint() public payable {
        require(balanceOf[msg.sender] + _value >= balanceOf[msg.sender]); // Check for overflows
        uint256 _value = msg.value / 100000000;
        updateAccount();

        require(unspent_supply - _value <= unspent_supply);
        unspent_supply -= _value; // Remove from unspent supply
        balanceOf[msg.sender] += _value; // Add the same to the recipient
        updateAccount();

        Mint(msg.sender, _value);                                    // Minting Completed Notification

    }

    function withdrawAmount(uint256 withdrawal_amount) public returns (bool) {

        require(balanceOf[msg.sender] >= withdrawal_amount);
        require(balanceOf[msg.sender] - withdrawal_amount <= balanceOf[msg.sender]);

        // Balance checked in BITS (currency), then converted into Wei
        balanceOf[msg.sender] -= withdrawal_amount;

        // Added back to supply in BITS
        unspent_supply += withdrawal_amount;
        // Converted into Wei
        withdrawal_amount *= 100000000;

        // Transfered in Wei
        msg.sender.transfer(withdrawal_amount);
        updateAccount();

        return true;
    }
}
