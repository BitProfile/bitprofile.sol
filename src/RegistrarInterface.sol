
contract RegistrarInterface is Owned
{
    function register(string) returns(bool);
    function link(string, Profile, string authData) returns(bool);
    function unlink(string, string authData) returns(bool);
    function contains(string) returns(bool);
    function get(string name) returns(Profile, uint);

    function moveContext(RegistrarInterface ) onlyowner;
    function getContext() returns(RegistrarContext);
    function kill() onlyowner;

    function() { throw; }
}

