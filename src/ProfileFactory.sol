contract ProfileFactory is ProfileFactoryInterface
{
    function create(address addr, string authData) returns(ProfileInterface)
    {
        return new Profile(new AddressAuth(addr));
    }
}
