contract MasterRegistrar is Owned
{
    RegistrarInterface[] context;
    RegistrarFactoryInterface factory;
    uint betaTimeout;
    uint betaLimit;

    function MasterRegistrar(uint betInterval, uint limit, RegistrarFactoryInterface fctr)
    {
        betaTimeout = block.number + betInterval;
        betaLimit = limit;
        factory = fctr;
    }

    function create() returns(bool)
    {
        if(beta() && context.length>=betaLimit)
        {
            return false;
        }
        context.push(factory.create());
        return true;
    }

    function get(uint index) returns(RegistrarInterface)
    {
        return context[index];
    }

    function size() returns(uint)
    {
        return context.length;
    }

    function upgrade(RegistrarFactoryInterface upgradedFactory) onlyowner onlybeta
    {
        factory = upgradedFactory;
        for(var i=0; i<context.length; i++)
        {
            RegistrarInterface oldRegistrar = context[i];
            RegistrarInterface registrar = factory.create(oldRegistrar.getContext());
            oldRegistrar.moveContext(registrar);
            context[i] = registrar;
            oldRegistrar.kill();
        }
    }

    function setFactory(RegistrarFactoryInterface newFactory) onlyowner onlybeta
    {
        factory = newFactory;
    }

    function upgradeRegistrar(uint index, RegistrarInterface upgraded) onlyowner onlybeta returns(bool)
    {
        if(index >= context.length)
        {
            return false;
        }
        RegistrarInterface registrar = context[index];
        registrar.moveContext(upgraded);
        context[index] = upgraded;
        registrar.kill();
        return true;
    }

    function beta() returns(bool)
    {
        return (betaTimeout>block.number);
    }

    function() { throw; }

    modifier onlybeta(){if(betaTimeout>block.number) _}

}
