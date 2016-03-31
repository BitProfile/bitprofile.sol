contract ProfileFactoryInterface 
{
    function create(address addr, bytes authData) returns(ProfileInterface);
}
