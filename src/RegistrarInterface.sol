
contract RegistrarInterface is Owned
{
    function register(bytes32, bytes) returns(bool);
    function link(bytes32, ProfileInterface, bytes authData) returns(bool);
    function unlink(bytes32, bytes authData) returns(bool);
    function contains(bytes32) returns(bool);
    function get(bytes32 name) returns(ProfileInterface, uint);
    function getProfile(bytes32 name) returns(ProfileInterface);

    function moveContext(RegistrarInterface ) onlyowner;
    function setFactory(ProfileFactoryInterface factory) onlyowner;
    function getContext() returns(RegistrarContextInterface);
    function kill() onlyowner;

    function() { throw; }
}

