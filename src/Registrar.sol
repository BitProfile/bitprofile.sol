

contract Registrar is RegistrarInterface
{

    RegistrarContext context;
    ProfileFactoryInterface factory;

    function Registrar(RegistrarContext ctx, ProfileFactoryInterface profileFactory, address addr)
    {
        context = ctx;
        factory = profileFactory;
        owner = addr;
    }


    function register(string name) returns(bool)
    {
        if(context.contains(name))
        {
            return false;
        }
        ProfileInterface profile = factory.create(msg.sender);
        context.replace(name, profile);
        return true;
    }

    function link(string name, ProfileInterface profile, string authData) returns(bool)
    {
        if(!profile.authenticate(msg.sender, authData, Auth.Permission.Owner))
        {
            return false;
        }
        return context.insert(name, profile);
    }


    function unlink(string name, string authData) returns(bool)
    {
        ProfileInterface profile = context.getProfile(name);
        if(profile.authenticate(msg.sender, authData, Auth.Permission.Owner))
        {
            context.remove(name);
            return true;
        }
        return false;
    }

    function contains(string name) returns(bool)
    {
        return context.contains(name);
    }

    function get(string name) returns(ProfileInterface, uint)
    {
        return context.get(name);
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

    function getContext() returns(RegistrarContext)
    {
        return context;
    }

}

