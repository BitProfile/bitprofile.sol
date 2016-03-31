

contract Registrar is RegistrarInterface
{

    RegistrarContextInterface context;
    ProfileFactoryInterface factory;

    function Registrar(RegistrarContextInterface ctx, ProfileFactoryInterface profileFactory, address addr)
    {
        context = ctx;
        factory = profileFactory;
        owner = addr;
    }


    function register(bytes32 name, bytes authData) returns(bool)
    {
        if(context.contains(name))
        {
            return false;
        }

        ProfileInterface profile = factory.create(msg.sender, authData);
        context.replace(name, profile);
        return true;
    }

    function link(bytes32 name, ProfileInterface profile, bytes authData) returns(bool)
    {
        if(!profile.authenticate(msg.sender, authData, Auth.Permission.Owner))
        {
            return false;
        }

        return context.insert(name, profile);
    }


    function unlink(bytes32 name, bytes authData) returns(bool)
    {
        ProfileInterface profile = context.getProfile(name);
        if(profile.authenticate(msg.sender, authData, Auth.Permission.Owner))
        {
            context.remove(name);
            return true;
        }
        return false;
    }

    function contains(bytes32 name) returns(bool)
    {
        return context.contains(name);
    }

    function get(bytes32 name) returns(ProfileInterface, uint)
    {
        return context.get(name);
    }

    function getProfile(bytes32 name) returns(ProfileInterface)
    {
        return context.getProfile(name);
    }

    function setFactory(ProfileFactoryInterface newFactory) onlyowner
    {
        factory = newFactory;
    }

    function moveContext(RegistrarInterface registrar) onlyowner
    {
        context.transfer(registrar);
    }

    function kill() onlyowner
    {
        suicide(msg.sender);
    }

    function getContext() returns(RegistrarContextInterface)
    {
        return context;
    }

    function getFactory() returns(ProfileFactoryInterface)
    {
        return factory;
    }

}

