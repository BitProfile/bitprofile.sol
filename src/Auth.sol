contract Auth{
    enum Permission{None, Edit, Manage, Owner}
    function authenticate(Permission permission) returns(bool);
}
