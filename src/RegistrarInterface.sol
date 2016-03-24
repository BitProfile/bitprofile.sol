
contract RegistrarInterface is Owned
{
    function register(string) returns(bool);
    function link(string, ProfileInterface, string authData) returns(bool);
    function unlink(string, string authData) returns(bool);
    function contains(string) returns(bool);
    function get(string name) returns(ProfileInterface, uint);

    function moveContext(RegistrarInterface ) onlyowner;
    function setFactory(ProfileFactoryInterface factory) onlyowner;
    function getContext() returns(RegistrarContext);
    function kill() onlyowner;

    function() { throw; }
}

