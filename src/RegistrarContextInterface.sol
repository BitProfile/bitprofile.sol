

contract RegistrarContextInterface is Owned
{
    struct ProfileLink
    {
        ProfileInterface profile;
        uint timestamp;
    }

    function insert(string name, ProfileInterface profile) onlyowner returns(bool);
    function replace(string name, ProfileInterface profile) onlyowner;
    function contains(string name) returns(bool);
    function remove(string name) onlyowner;
    function getProfile(string name) returns(ProfileInterface);
    function get(string name) returns(ProfileInterface, uint);


}
