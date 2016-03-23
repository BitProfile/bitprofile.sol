contract Auth{
    enum Permission{None, Edit, Manage, Owner}
    function authenticate(address, string, Permission) returns(bool);
}
