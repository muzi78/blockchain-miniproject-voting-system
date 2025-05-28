// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract VotingSystem {
    address public owner;
    
    // Track if an address is registered to vote
    mapping(address => bool) public isRegistered;
    
    // Track if an address has already voted
    mapping(address => bool) public hasVoted;
    
    // Track votes for each party (0 = PTI, 1 = PMLN)
    uint256 public ptiVotes;
    uint256 public pmlnVotes;
    
    // Events for logging actions
    event VoterRegistered(address indexed voter);
    event VoterRemoved(address indexed voter);
    event VoteCast(address indexed voter, uint256 party);
    
    constructor() {
        owner = msg.sender;
    }
    
    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can perform this action");
        _;
    }
    
    // Register a voter (only owner can do this)
    function registerVoter(address _voter) public onlyOwner {
        require(!isRegistered[_voter], "Voter already registered");
        isRegistered[_voter] = true;
        emit VoterRegistered(_voter);
    }
    
    // Remove a voter (only owner can do this)
    function removeVoter(address _voter) public onlyOwner {
        require(isRegistered[_voter], "Voter not registered");
        isRegistered[_voter] = false;
        emit VoterRemoved(_voter);
    }
    
    // Cast a vote (0 = PTI, 1 = PMLN)
    function castVote(address _voter, uint256 _party) public {
        require(isRegistered[_voter], "Voter not registered");
        require(!hasVoted[_voter], "Already voted");
        require(_party == 0 || _party == 1, "Invalid party selection");
        
        hasVoted[_voter] = true;
        
        if (_party == 0) {
            ptiVotes++;
        } else {
            pmlnVotes++;
        }
        
        emit VoteCast(_voter, _party);
    }
    
    // Check if an address is registered to vote
    function checkVoterStatus(address _voter) public view returns (bool) {
        return isRegistered[_voter];
    }
    
    // Check if an address has already voted
    function checkIfVoted(address _voter) public view returns (bool) {
        return hasVoted[_voter];
    }
    
    // Get total votes for PTI
    function getPTIVotes() public view returns (uint256) {
        return ptiVotes;
    }
    
    // Get total votes for PMLN
    function getPMLNVotes() public view returns (uint256) {
        return pmlnVotes;
    }
    
    // Transfer ownership (only owner can do this)
    function transferOwnership(address newOwner) public onlyOwner {
        require(newOwner != address(0), "New owner cannot be zero address");
        owner = newOwner;
    }
}