contract ProfileInterface
{
    function authenticate(address addr, bytes authData, Auth.Permission permission) returns(bool);
    function get(string key) returns(string);
}
