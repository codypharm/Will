
pragma solidity >=0.7.0 <0.9.0;

contract Will {
    
    address owner;
    bool   deceased;
    address payable [] familyWallets;
    uint fortune;
    
    mapping(address => uint256) inheritance;

    constructor() payable public{
        owner = msg.sender;
        deceased = false;
        fortune = msg.value;
        
    }
    
    modifier onlyOwner(){
        //ensure the caller is the owner
        require(msg.sender == owner);
        _;
    }
    
    modifier hasChildren(){
        require(familyWallets.length > 0);
        _;
    }
    
    //set inheritance for each benefactor
    function setInheritance(address payable wallet, uint amount) public onlyOwner{
        //ensure owner still has such asset
        require (fortune >= amount);
        //ensure owner does not enlist him self as benefator
        require (wallet != owner);
        inheritance[wallet] = amount;
        familyWallets.push(wallet);
        fortune -= amount;
    }
    
    function sendMoney() private hasChildren{
        //ensure owner is dead
        require(deceased == true);
        for(uint i = 0; i< familyWallets.length; i++){
            familyWallets[i].transfer(inheritance[familyWallets[i]]);
        }
    }
    
    function setDeceased() public  onlyOwner{
        //mark owner as dead
        deceased = true;
        //share asset
        sendMoney();
    }
    
    
    
}