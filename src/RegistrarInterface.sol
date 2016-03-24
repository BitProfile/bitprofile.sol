
contract RegistrarInterface is Owned
{
    function register(string, string) returns(bool);
    function link(string, ProfileInterface, string authData) returns(bool);
    function unlink(string, string authData) returns(bool);
    function contains(string) returns(bool);
    function get(string name) returns(ProfileInterface, uint);
    function getProfile(string name) returns(ProfileInterface);

    function moveContext(RegistrarInterface ) onlyowner;
    function setFactory(ProfileFactoryInterface factory) onlyowner;
    function getContext() returns(RegistrarContextInterface);
    function kill() onlyowner;

    function() { throw; }
}

