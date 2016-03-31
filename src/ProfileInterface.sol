contract ProfileInterface
{
    function authenticate(address addr, bytes authData, Auth.Permission permission) returns(bool);
    function get(bytes32 key) returns(bytes);
}
