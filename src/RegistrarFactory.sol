contract RegistrarFactory is RegistrarFactoryInterface
{
    function create() returns(RegistrarInterface)
    {
        RegistrarContext context = new RegistrarContext();
        Registrar registrar = new Registrar(context, msg.sender);
        context.transfer(registrar);
        return registrar;
    }

    function create(RegistrarContext context) returns(RegistrarInterface)
    {
        return new Registrar(context, msg.sender);
    }
}
