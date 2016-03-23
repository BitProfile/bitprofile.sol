
contract Profile {

    event Change(
        string key,
        string value
    );

    mapping(string => string) data;
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

    function set(string key, string value, string authData) authenticated(authData, Auth.Permission.Edit)
    {
        data[key] = value;
        Change(key, value);
    }

    function clear(string key, string authData) authenticated(authData, Auth.Permission.Edit)
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

}


