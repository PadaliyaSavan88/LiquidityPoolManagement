// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.16;

contract Lending {

    // address of owner
    address public owner;
    uint public lendersId;
    
    struct lenders {
        uint ID;
        uint lendingDate; 
        uint amount;
    }

    mapping(address => lenders) public Lenders;

    // assign constructor caller address to be owner
    constructor() { 
        owner = msg.sender;
    }

    modifier exitPoolValidation(address _user, uint _value) {
        require(Lenders[_user].ID > 0, "No Tokens Lended Yet");
        require(Lenders[_user].amount == 0, "Insufficient Balance In Pool");
        uint dayDifference = getTimeDifference(_user);
        require(Lenders[_user].amount * (25*dayDifference)/100 >= _value, "Withdrawl amount restricted");
        _;
    }

    function enterPool(address _user, uint _value) public {
        lendersId++;
        Lenders[_user]= lenders(lendersId, block.timestamp, _value);
    }

    function getTimeDifference(address _user) internal view returns(uint) {
        uint timeDiff = Lenders[_user].lendingDate - block.timestamp;
        if(timeDiff < 2 days) return 0;
        else if (timeDiff < 4 days) return 1;
        else if (timeDiff < 6 days) return 2;
        else if (timeDiff < 8 days) return 3;
        else return 4;
    }

    function calculateTaxOnExit(address _user) internal view returns(uint) {
        uint dayDifference = getTimeDifference(_user);
        if(dayDifference == 0) return 0;
        else if (dayDifference == 1) return Lenders[_user].amount * 75 / 100;
        else if (dayDifference == 2) return Lenders[_user].amount * 50 / 100;
        else if (dayDifference == 3) return Lenders[_user].amount * 25 / 100;
        else if (dayDifference == 4) return Lenders[_user].amount;
        else return 0;
    }

    function getExitPoolStatus(address _user, uint _value, uint tax) public  exitPoolValidation(_user, _value) view returns(uint) {
        uint dayDifference = getTimeDifference(_user);
        if(dayDifference == 0) return 0 + tax;
        else if (dayDifference == 1) return Lenders[_user].amount * 25 / 100 + tax;
        else if (dayDifference == 2) return Lenders[_user].amount * 50 / 100 + tax;
        else if (dayDifference == 3) return Lenders[_user].amount * 75 / 100 + tax;
        else if (dayDifference == 4) return Lenders[_user].amount + tax;
        else return 0 + tax;
    }

    function getExitPoolEstimation(address _user, uint _value) public view {
        uint _tax = calculateTaxOnExit(_user);
        getExitPoolStatus(_user, _value, _tax);
    }

    function exitPool(address _user, uint _value) public payable exitPoolValidation(_user, _value) {
        // uint timeDiff = Lenders[_user].lendingDate - block.timestamp;
    }

}