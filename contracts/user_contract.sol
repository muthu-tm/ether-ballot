pragma solidity ^0.5.0;

contract User {
    
    string  public name;
    uint    public age;
    string  public gender;
    address public userAddress;
    address public contractAddress;
    string  public votedCandidate;

    mapping(address => uint256) userAccessMapping;
    
    constructor(string memory _name, uint _age, string memory _gender, address _userAddress) public {
        name        = _name;
        age         = _age;
        gender      = _gender;
        userAddress =  _userAddress;
    }
    
    function setVotedCandidate(string memory _votedCandidate) public {
        votedCandidate = _votedCandidate;
    }
    
    /**
     * 
     * @dev Checks whether the caller has access to this user ContractAccess
     * @return Boolean value that represents the accessibility
     */
    function checkAccess() public view returns(bool) {
        if (userAccessMapping[msg.sender] != 0)
            return true;
        else
            return false;
    }
    
    /**
     * 
     * @dev Gives access to the new suer by updating it's access mapping
     * @return Boolean value that represents whether the access given or not
     * 
     */
    function updateAccessList(address _user, uint256 _expireAt) public returns(bool) {
        userAccessMapping[_user] = block.timestamp + _expireAt * 1 days ;
        return true;
    }
    
    function getContractAddress() public view returns(address) {
        return contractAddress;
    }
    
    function setContractAddress(address _contractAddress) public {
        contractAddress = _contractAddress;
    }
    
}