contract ProfileFactory is ProfileFactoryInterface
{
    function create(address addr, bytes authData) returns(ProfileInterface)
    {
        return new Profile(new AddressAuth(addr));
    }
}
