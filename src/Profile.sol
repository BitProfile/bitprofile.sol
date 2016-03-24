
contract Profile is ProfileInterface
{

    event Change(
        string key,
        string value
    );

    mapping(string => string) data;
    mapping(string => Auth.Permission) permissions;
    Auth public auth;

    function Profile(Auth owner)
    {
        auth = owner;
    }

    function authenticate(address addr, string authData, Auth.Permission permission) returns(bool)
    {
        return auth.authenticate(addr, authData, permission);
    }

    function get(string key) returns(string)
    {
        return data[key];
    }

    function set(string key, string value, string authData) editPermission(key, authData)
    {
        data[key] = value;
        Change(key, value);
    }

    function setPermission(string key, Auth.Permission permission, string authData) authenticated(authData, Auth.Permission.Manage)
    {
        permissions[key] = permission;
    }

    function clear(string key, string authData) editPermission(key, authData)
    {
        delete data[key];
    }

    function transfer(Auth owner, string authData) authenticated(authData, Auth.Permission.Owner)
    {
        auth = owner;
    }

    function kill(string authData) authenticated(authData, Auth.Permission.Owner)
    {
        suicide(msg.sender);
    }


    function() { throw; }

    modifier authenticated(string authData, Auth.Permission permission) { if (auth.authenticate(msg.sender, authData, permission)) _ }
    modifier editPermission(string key, string authData)
    {
        Auth.Permission permission = permissions[key];
        if(permission < Auth.Permission.Edit) permission = Auth.Permission.Edit;
        if(auth.authenticate(msg.sender, authData, permission)) _
    }

}


