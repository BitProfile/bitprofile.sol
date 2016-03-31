contract Auth{
    enum Permission{None, Edit, Manage, Owner}
    function authenticate(address, bytes, Permission) returns(bool);
}
