contract RegistrarFactoryInterface
{
    function create() returns(RegistrarInterface);
    function create(RegistrarContext) returns(RegistrarInterface);
}
