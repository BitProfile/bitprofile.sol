contract ProfileFactoryInterface 
{
    function create(address addr, string authData) returns(ProfileInterface);
}
