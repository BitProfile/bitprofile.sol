

contract RegistrarContext is RegistrarContextInterface
{
    mapping(bytes32 => ProfileLink) profiles;


    function insert(bytes32 name, ProfileInterface profile) onlyowner returns(bool)
    {
        if(contains(name))
        {
            return false;
        }
        replace(name, profile);
        return true;
    }

    function replace(bytes32 name, ProfileInterface profile) onlyowner
    {
        profiles[name] = ProfileLink(profile, block.timestamp);
    }


    function contains(bytes32 name) returns(bool)
    {
        return profiles[name].timestamp!=0;
    }

    function remove(bytes32 name) onlyowner
    {
        delete profiles[name];
    }


    function getProfile(bytes32 name) returns(ProfileInterface)
    {
        return profiles[name].profile;
    }


    function get(bytes32 name) returns(ProfileInterface, uint)
    {
        ProfileLink link = profiles[name];
        return (link.profile, link.timestamp);
    }

}
