

contract Registrar is RegistrarInterface
{

    RegistrarContext context;

    function Registrar(RegistrarContext ctx, address addr)
    {
        context = ctx;
        owner = addr;
    }


    function register(string name) returns(bool)
    {
        if(context.contains(name))
        {
            return false;
        }
        Profile profile = new Profile(new AddressAuth(tx.origin));
        context.replace(name, profile);
        return true;
    }

    function link(string name, Profile profile) returns(bool)
    {
        if(!profile.authenticate(Auth.Permission.Owner))
        {
            return false;
        }
        return context.insert(name, profile);
    }

    function remove(string name) returns(bool)
    {
        Profile profile = context.getProfile(name);
        if(unlink(name, profile))
        {
            profile.kill();
            return true;
        }
        return false;
    }

    function unlink(string name) returns(bool)
    {
        Profile profile = context.getProfile(name);
        return unlink(name, profile);
    }

    function unlink(string name, Profile profile) private returns(bool)
    {
        if(profile.authenticate(Auth.Permission.Owner))
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

    function get(string name) returns(Profile, uint)
    {
        return context.get(name);
    }

    function moveContext(RegistrarInterface registrar) onlyowner
    {
        context.transfer(registrar);
    }

    function kill() onlyowner
    {
        suicide(tx.origin);
    }

    function getContext() returns(RegistrarContext)
    {
        return context;
    }

}

