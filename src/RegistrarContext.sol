

contract RegistrarContext is Owned
{
    struct ProfileLink
    {
        Profile profile;
        uint timestamp;
    }

    mapping(string => ProfileLink) profiles;


    function insert(string name, Profile profile) onlyowner returns(bool)
    {
        if(contains(name))
        {
            return false;
        }
        replace(name, profile);
        return true;
    }

    function replace(string name, Profile profile) onlyowner
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


    function getProfile(string name) returns(Profile)
    {
        return profiles[name].profile;
    }


    function get(string name) returns(Profile, uint)
    {
        ProfileLink link = profiles[name];
        return (link.profile, link.timestamp);
    }


}
