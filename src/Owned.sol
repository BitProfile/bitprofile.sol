contract Owned {
    function Owned() { owner = msg.sender; }
    function transfer(address addr) onlyowner {owner = addr;}
    modifier onlyowner(){if(msg.sender==owner) _}
    address owner;
}
