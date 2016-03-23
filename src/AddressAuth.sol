contract AddressAuth is Auth{

    enum Operation{Removed, Added}
    event Change(address, Permission, Operation);

    function AddressAuth(address owner)
    {
        owners[owner] = Permission.Owner;
    }

    function set(address addr, Permission permission) returns(bool)
    {
        Permission perm = owners[msg.sender];
        if(perm < Permission.Manage || perm < permission)
        {
            return false;
        }
        owners[addr] = permission;
        Change(addr, permission, Operation.Added);
        return true;
    }

    function remove(address addr) returns(bool)
    {
        Permission perm = owners[msg.sender];
        if(perm < Permission.Manage || perm < owners[addr] || msg.sender==addr)
        {
            return false;
        }
        delete owners[addr];
        Change(addr, perm, Operation.Removed);
        return true;
    }

    function authenticate(address addr, string authData, Permission permission) returns(bool)
    {
        return owners[addr] >= permission;
    }

    mapping(address=> Permission) public owners;


}


