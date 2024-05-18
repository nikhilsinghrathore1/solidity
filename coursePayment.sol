// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Ownable {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

  
    constructor(address initialOwner) {
        _transferOwnership(initialOwner);
    }

 
    modifier onlyOwner() {
        _checkOwner();
        _;
    }

   
    function owner() public view virtual returns (address) {
        return _owner;
    }

    
    function _checkOwner() internal view virtual {
        require(owner() == msg.sender);
    }

    
    
    function renounceOwnership() public virtual onlyOwner {
        _transferOwnership(address(0));
    }

  
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(owner() == msg.sender);
        _transferOwnership(newOwner);
    }

   
    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}

contract coursePayment is Ownable{
  uint public courseFee;
    payment[] public payments;

    event paymentRecieved(address indexed user , string email , uint256 amount);
    struct payment {
        address user; 
        string email;
        uint amount;
    }
    constructor(uint256 _courseFee)Ownable(msg.sender){
        courseFee = _courseFee;
    }

    function PayForCourse(string memory email) public payable{
        require(msg.value == courseFee);
        payments.push(payment(msg.sender,email,msg.value));
        emit paymentRecieved(msg.sender, email, msg.value);
    }


    function getPaymentByUser(address userAddress)public view returns(payment[] memory){
        uint256 count = 0 ;
        for(uint i = 0 ; i < payments.length; i ++){
            if(payments[i].user == userAddress){
                count++;
            }
        }

        payment[] memory userPayment = new payment[](count);
        uint256 index = 0; 
        for(uint i = 0 ; i <payments.length; i++){
            if(payments[i].user == userAddress){
                userPayment[index] = payments[i];
                index++;
            }
        } 
        return userPayment;
    }

    function getAllPayments() public view returns(payment[] memory){
        return payments;
    }

}