contract ProfileFactory is ProfileFactoryInterface
{
    function create(address addr) returns(ProfileInterface)
    {
        return new Profile(new AddressAuth(addr));
    }
}
