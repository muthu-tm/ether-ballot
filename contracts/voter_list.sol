pragma solidity ^0.5.0;

import "./user_contract.sol";

contract VoterList {
    
    User user;
    
    uint256 expireAt = 5;
    uint256 public totalVotes;
    
    User[] public users;
    address[] public userAddressList;
     
    mapping(address => User) private addressUserMapping;
    mapping(address => address) private contractUserMapping;
    
    function createUser(string calldata _name, uint _age, string calldata _gender, address _userAddress) external {
        User userContract = new User(_name, _age, _gender, _userAddress);
        address contractAddress = address(userContract);
        
        userContract.setContractAddress(contractAddress);
        users.push(userContract);
        addressUserMapping[_userAddress] = userContract;
        userAddressList.push(_userAddress);
        contractUserMapping[contractAddress] = _userAddress;
    }
    
    function updateUserVote(address _userAddress, string memory _votedCandidate) public returns(string memory){
        User userContract = User(addressUserMapping[_userAddress]);
        
        // update the user's voted candidate name, soon after vote casted by this user
        userContract.setVotedCandidate(_votedCandidate);
        
        // update total votes count to cross check with the ballot votes count
        totalVotes += 1;
        
        return userContract.name();
    }
    
    function getDetails(address _userAddress) public view returns(User) {
        User userContract = User(addressUserMapping[_userAddress]);
        
        // check whether the caller has the access to this use contract
        require(userContract.checkAccess());
        return userContract;
    }
    
    function giveAccess(address _userAddress, uint256 _expireAt) public returns(bool) {
        User userContract = User(addressUserMapping[_userAddress]);
        
        if (_expireAt > 0) {
            // provide the given expiry
            return userContract.updateAccessList(_userAddress, _expireAt);
        } else {
            // provide default expiry days i.e) 5
            return userContract.updateAccessList(_userAddress, expireAt);
        }
        
        return false;
    }
    
    function getAllVoters() public view returns(address[] memory){
        return userAddressList;
    }
    
    function getContractAddress(address _userAddress) public view returns(address) {
        User userContract =  User(addressUserMapping[_userAddress]);
        return userContract.getContractAddress();
    }
    
    function getUserDetails(address _contractAddress) public view returns(User) {
       address userAddress = contractUserMapping[_contractAddress];
       User userContract = addressUserMapping[userAddress];
       return userContract;
        
    }
    
    function isRegisteredUser(address _userAddress) public view returns(bool) {
        User userContract = User(addressUserMapping[_userAddress]);
        
        // By default mapping will return a user with default values, uint default is "0";
        // checking against with would give us expected result
        if(userContract.age() > 0) {
            return true;
        } else {
            return false;
        }
    }
    
    function getMyVote() public view returns(string memory) {
        User userContract = User(addressUserMapping[msg.sender]);
        return userContract.votedCandidate();
    }
    
    function hasVoted(address _voter) public view returns(bool) {
        for(uint index = 0; index < userAddressList.length; index++ ) {
            if (userAddressList[index] == _voter)
                return true;
        }
        
        return false;
    }
    
    function getVoterName(address _voter) public view returns(string memory) {
        User userContract = User(addressUserMapping[_voter]);
        return userContract.name();
    }
    
    function getTotalVotes() public view returns(uint256) {
        return totalVotes;
    }
}