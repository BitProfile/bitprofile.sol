contract RegistrarFactory is RegistrarFactoryInterface
{
    ProfileFactory factory;

    function RegistrarFactory(ProfileFactory profileFactory)
    {
        factory = profileFactory;
    }

    function create() returns(RegistrarInterface)
    {
        RegistrarContext context = new RegistrarContext();
        Registrar registrar = new Registrar(context, factory, msg.sender);
        context.transfer(registrar);
        return registrar;
    }

    function create(RegistrarContextInterface context) returns(RegistrarInterface)
    {
        return new Registrar(context, factory, msg.sender);
    }
}
