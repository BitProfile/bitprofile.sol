

contract RegistrarContext is RegistrarContextInterface
{
    mapping(string => ProfileLink) profiles;


    function insert(string name, ProfileInterface profile) onlyowner returns(bool)
    {
        if(contains(name))
        {
            return false;
        }
        replace(name, profile);
        return true;
    }

    function replace(string name, ProfileInterface profile) onlyowner
    {
        profiles[name] = ProfileLink(profile, block.timestamp);
    }


    function contains(string name) returns(bool)
    {
        return profiles[name].timestamp!=0;
    }

    function remove(string name) onlyowner
    {
        delete profiles[name];
    }


    function getProfile(string name) returns(ProfileInterface)
    {
        return profiles[name].profile;
    }


    function get(string name) returns(ProfileInterface, uint)
    {
        ProfileLink link = profiles[name];
        return (link.profile, link.timestamp);
    }


}
