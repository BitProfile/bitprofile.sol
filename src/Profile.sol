
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

    function authenticate(Auth.Permission permission) returns(bool)
    {
        return auth.authenticate(permission);
    }

    function get(string key) returns(string)
    {
        return data[key];
    }

    function set(string key, string value) authenticated(Auth.Permission.Edit)
    {
        data[key] = value;
        Change(key, value);
    }

    function clear(string key) authenticated(Auth.Permission.Edit)
    {
        delete data[key];
    }

    function transfer(Auth owner) authenticated(Auth.Permission.Owner)
    {
        auth = owner;
    }

    function kill() authenticated(Auth.Permission.Owner)
    {
        suicide(msg.sender);
    }

    function() { throw; }

    modifier authenticated(Auth.Permission permission) { if (auth.authenticate(permission)) _ }

}


