contract ProfileInterface
{
    function authenticate(address addr, string authData, Auth.Permission permission) returns(bool);
    function get(string key) returns(string);
}
