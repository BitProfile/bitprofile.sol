contract AddressAuth is Auth{

    enum Operation{Removed, Added}
    event Change(address, Permission, Operation);

    function AddressAuth(address owner)
    {
        owners[owner] = Permission.Owner;
    }

    function set(address addr, Permission permission) returns(bool)
    {
        Permission perm = owners[tx.origin];
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
        Permission perm = owners[tx.origin];
        if(perm < Permission.Manage || perm < owners[addr] || tx.origin==addr)
        {
            return false;
        }
        delete owners[addr];
        Change(addr, perm, Operation.Removed);
        return true;
    }

    function authenticate(Permission permission) returns(bool)
    {
        return owners[tx.origin] >= permission;
    }

    mapping(address=> Permission) public owners;


}

