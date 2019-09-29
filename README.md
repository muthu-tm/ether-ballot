# ether_ballot

## Ballot
### Variables
* List of candidates
* Voting time period
* List of all ECI members
* Votes each candidate has received.
* User address => candidate voted mapping

### Functions:
* Get My Vote: input none, returns candidate which the querying user has voted, false if not voted yet.
* Get Results: if the voting has ended, return the votes each candidate has received.
* Cast Vote: If user in voter list, cast their vote, also update their individual contract for the same
* Get Users Vote: input user address, returns the candidate the user has voted, false if not voted yet, throw error if no user exists.
* Get Vote Map : input none, returns list of users and the votes they have cast.
* Consolidate votes: Match votes from ballot contract and summation of votes in each users contracts. Basically there are two copies of the votes cast, one with the users contract and one in the ballot contract. Throw an error if there are any discrepancies. Take care of users who have not voted yet

## VoterList:
### Variables
* List of all registered voters
* Mapping of Citizen address to citizen contract address.

### Functions: 
* Get all voters: input none,returns list of Users address
* Get contract address: input (user address) returns users contract address
* Get user details: input (contract address) returns user details
* isRegistered: input none, returns true or false depending on whether the querying user is registered.

## Individual User Contract:
### Variables
* Name
* Age
* Gender
* Address
* Vote given to(once vote is given)
* Permission to access contract (will be addresses of other users), should also maintain the expiry of that address to the Particular users contract.

### Functions:
* Get Details: input none, returns the details, check the address of msg.sender to make sure either it is the user querying the detail, or a member of the ECI or some one the user has given access
* Give access: input address, expiry, returns true or false of whether the permission was set. Take a default value for expiry if expiry is not provided.
