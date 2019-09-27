pragma solidity ^0.5.0;
pragma experimental ABIEncoderV2;

import "./utils.sol";
import "./user_contract.sol";
import "./voter_list.sol";

/**
 * @title Ballout
 */
contract Ballout is VoterList {
    
    VoterList voterList;
    Utils     utils;
    
    struct Candidate {
        address candidateAddress;
        string  name;
        uint    voteCount;
    }
    
     struct VoteMap {
        string userName;
        string candidate;
    }
    
    struct Member {
        address memberAddress;
        string  name;
    }
    
    Candidate[] private candidates;
    Member[]    private members;
    VoteMap[]   private voteMapList;
    address private owner;

    
    mapping(address => Candidate) private voteMapWithAddress;
    address[] private castedVoters;
    
    uint256 private votesCount;
    uint256 private openingTime;
    uint256 private closingTime;
    
    /**
     * @dev Check whether the voting period is open
     */
    modifier isCastingOpen {
        require(block.timestamp >= openingTime && block.timestamp <= closingTime);
         _;
    }
    
    /**
     * @dev Checks whether the vote casting is period has already elapsed.
     */
    modifier hasClosed() {
        require(block.timestamp > closingTime);
        _;
    }
    
    /**
     * @dev Check whether the voting period is open
     */
    modifier onlyMembers {
        bool isMember = false;
        for (uint index = 0; index < members.length; index++) {
            if (members[index].memberAddress == msg.sender) {
                isMember = true;
                break;
            }
        }
        
        if (isMember)
            _;
    }
    
    modifier onlyOwner(){
        require(msg.sender == owner, "You cannot add new member into the network");
        _;
    }
    
    /**
     * @dev Constructor, takes Voting Period opening and closing times.
     * @param _openingTime Voting Period opening time
     * @param _closingTime Voting Period closing time
     */
    constructor (uint256 _openingTime, uint256 _closingTime) public {
        require(_openingTime >= block.timestamp, "Voting Period: opening time is before current time");
        require(_closingTime > _openingTime, "Voting Period: opening time is not before closing time");

        openingTime = _openingTime;
        closingTime = _closingTime;
        votesCount = 0;
        
        owner = msg.sender;
    }
    
    /**
     * Get User voted candidate name
     * @return retruns candidate name if the user casted their vote
     */
    function getMyVote() public view returns(string memory) {
        require(voterList.hasVoted(msg.sender), "Not yet voted");
        return voteMapWithAddress[msg.sender].name;
    }
    
    /**
     * @dev Get User voted candidate name
     * @return retruns candidate name if the user casted their vote
     */
    function getResults() hasClosed public view returns(Candidate[] memory) {
        return candidates;
    }
    
    function castVote(string memory _name) isCastingOpen internal {
        require(voterList.hasVoted(msg.sender));
        string memory userName = voterList.updateUserVote(msg.sender, _name);
        Candidate memory candidate = updateCandidate(_name);
        voteMapWithAddress[msg.sender] = candidate;
        castedVoters.push(msg.sender);
        voteMapList.push(VoteMap(userName, _name));
        votesCount += 1;
    }
    
    function getUserVote(address _user) onlyMembers internal view returns(string memory) {
        require(voterList.isRegisteredUser(_user), "No user found for this address");
        require(voterList.hasVoted(msg.sender), "false");
        return voteMapWithAddress[_user].name;
    }
    
    function getVoteMap() onlyMembers internal view returns(VoteMap[] memory) {
       return voteMapList;
    }
    
    function consolidateVotes() onlyMembers internal view returns(bool) {
        if (votesCount == voterList.getTotalVotes()) {
            return true;
        } else {
            return false;
        }
    }
    
    function updateCandidate(string memory _name) internal returns(Candidate memory) {
        Candidate memory candidate;
        for (uint index = 0; index < candidates.length; index++) {
            if (utils.equal(candidates[index].name, _name)) {
                candidates[index].voteCount += 1;
                candidate = candidates[index];
                break;
            }
        }
        return candidate;
    }
    
    /**
     * @dev Extend Voting period.
     * @param _newClosingTime Voting new closing time to update
     */
    function extendClosingTime(uint256 _newClosingTime) internal {
        require(_newClosingTime > closingTime, "Voting period: new closing time is before current closing time");

        closingTime = _newClosingTime;
    }
    
    /**
     * @dev Adding new ECI member to the network
     * Only the contract owner can add a new member
     * 
     */
    function addMembers(address _memAddress, string memory _name) onlyOwner public {
        members.push(Member(_memAddress, _name));
    }
    
    function addUser(string memory _name, uint256 _age, string memory _gender, address _userAddress) onlyMembers public {
        voterList.createUser(_name, _age, _gender, _userAddress);
    }
    
    function addCandidate(address _candidateAddress, string memory _name) onlyMembers public {
        candidates.push(Candidate(_candidateAddress, _name, 0));
    }
}
