
contract Profile is ProfileInterface
{

    event Change(
        bytes32 key,
        bytes value
    );

    mapping(bytes32 => bytes) data;
    mapping(bytes32 => Auth.Permission) permissions;
    Auth public auth;

    function Profile(Auth owner)
    {
        auth = owner;
    }

    function authenticate(address addr, bytes authData, Auth.Permission permission) returns(bool)
    {
        return auth.authenticate(addr, authData, permission);
    }

    function get(bytes32 key) returns(bytes)
    {
        return data[key];
    }

    function set(bytes32 key, bytes value, bytes authData) editPermission(key, authData)
    {
        data[key] = value;
        Change(key, value);
    }

    function setPermission(bytes32 key, Auth.Permission permission, bytes authData) authenticated(authData, Auth.Permission.Manage)
    {
        permissions[key] = permission;
    }

    function clear(bytes32 key, bytes authData) editPermission(key, authData)
    {
        delete data[key];
    }

    function transfer(Auth owner, bytes authData) authenticated(authData, Auth.Permission.Owner)
    {
        auth = owner;
    }

    function kill(bytes authData) authenticated(authData, Auth.Permission.Owner)
    {
        suicide(msg.sender);
    }


    function() { throw; }

    modifier authenticated(bytes authData, Auth.Permission permission) { if (auth.authenticate(msg.sender, authData, permission)) _ }
    modifier editPermission(bytes32 key, bytes authData)
    {
        Auth.Permission permission = permissions[key];
        if(permission < Auth.Permission.Edit) permission = Auth.Permission.Edit;
        if(auth.authenticate(msg.sender, authData, permission)) _
    }

}


