contract RegistrarFactoryInterface
{
    function create() returns(RegistrarInterface);
    function create(RegistrarContextInterface) returns(RegistrarInterface);
}
