# LagDetection
A simple plugin that monitors if the server is lagging or not and takes some action. This plugin will work **exclusively in** [Helix](https://github.com/NebulousCloud/helix) **gamemode 
from** [NebulousCloud](https://github.com/NebulousCloud).

The plugin was developed by **AsterionProject**. Discord of our project: [discord.gg/Cz3EQJ7WrF](https://discord.gg/Cz3EQJ7WrF)
![asterion](https://i.imgur.com/qJtYDKM.png)

New hook that adds the plugin:
```lua
-- Called only when the ``server lags`` more than specified in the config
-- @rate return the server lag value
-- can only be run on the ``SERVER`` side
PLUGIN:LagDetection(rate)
```

Values that can be changed
```lua
PLUGIN.rate_limit = 3 -- How much the server should lag for the ``PLUGIN.lag_limit`` variable to be added by 1
PLUGIN.lag_limit = 4 -- Server lag limit
PLUGIN.sendclient = true -- Whether the server will transmit information to all players on the server when the ``PLUGIN.lag_limit'' is raised
```

You can easily add new values, which will happen to the theme or other entity, during any action. An example is shown below.
Table **PLUGIN.ents_list**:

![code1](https://i.imgur.com/AAUEOUl.png)
