

contract RegistrarContextInterface is Owned
{
    struct ProfileLink
    {
        ProfileInterface profile;
        uint timestamp;
    }

    function insert(bytes32 name, ProfileInterface profile) onlyowner returns(bool);
    function replace(bytes32 name, ProfileInterface profile) onlyowner;
    function contains(bytes32 name) returns(bool);
    function remove(bytes32 name) onlyowner;
    function getProfile(bytes32 name) returns(ProfileInterface);
    function get(bytes32 name) returns(ProfileInterface, uint);


}
