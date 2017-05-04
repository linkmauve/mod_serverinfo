--
-- mod_serverinfo by Thomas Leister <thomas.leister@mailbox.org>
--

--
-- Config options in prosody.cfg.lua (global namespace):
-------------------------------------------------------------
--
-- serverinfo = {
--     admin_name = "Thomas Leister";
--     admin_email = "xmpp@trashserver.net";
--     admin_web = "https://trashserver.net";
--
--     location_name = "Servercow";
--     location_coords_long = 666;
--     location_coords_lat = 42;
--
--     cache_ttl = 60;
-- }


module:depends("http");

local log = require "util.logger".init("mod_serverinfo");
local json = require "util.json".encode;
local url = require("socket.url");

local vhosts = prosody.hosts;
local serverinfo_settings = module:get_option("serverinfo", {});
local jsonresponse;
local cache_updated;
local cache_ttl = serverinfo_settings.cache_ttl or 60;
--local cache_ttl = 60;

function processHost(vhostname)
    vhost = hosts[vhostname]

    -- Object for JSON output.
    vhostjson = {
        name = vhostname,
        connections = {
            s2s = {
                incoming = {},
                outgoing = {}
            },
            c2s = {
                count = 0
            }
        },
        users_connected = 0
    }

    local users_connected = 0
    local c2s_connection_count = 0
    local servers_outgoing = { {dummy=true} }     -- Workaround: These two have a dummy object in them, which lets Lua interpret table as array, not as object, even
    local servers_incoming = { {dummy=true} }     -- If we left this empty, Lua would interpret this as object, which would generate wrong json output! Dummy elements fill be filtered from json output.

    -- Count online users
	if vhost.sessions then
        for username in pairs(vhost.sessions) do
			users_connected = users_connected + 1
            -- log("debug", "User %s is online.", username)

            -- how many resources (client connections?)
            for resource in pairs(vhost.sessions[username].sessions) do
                -- log("debug", "Found resource: %s", resource)
                c2s_connection_count = c2s_connection_count + 1
            end
		end
        log("debug", ">>> vHost %s has %d online users and %d c2s connections.", vhostname, users_connected, c2s_connection_count);
    else
        log("debug", ">>> vHost seems to be component vhost.", vhostname);
	end


    --
    -- Count S2S connections
    --

    -- Outgoing s2s connections
    for _, conn in pairs(vhost.s2sout) do
        table.insert(servers_outgoing, { to = conn.to_host })
        log("debug", "Outgoing connection to %s", conn.to_host)
    end

    -- Loop through global incoming connections and select connections to this vhost
    for conn, _ in pairs(prosody.incoming_s2s) do
        if conn.to_host == vhostname then
            table.insert(servers_incoming, { from = conn.from_host })
            log("debug", "Incoming connection from %s", conn.from_host)
        end
    end

    -- fill vhostjson with values
    vhostjson.connections.s2s.outgoing = servers_outgoing
    vhostjson.connections.s2s.incoming = servers_incoming
    vhostjson.connections.c2s.count = c2s_connection_count
    vhostjson.users_connected = users_connected


    return vhostjson
end


function allvHosts()
    local vhostsjson = {}

    for vhostname, _ in pairs(hosts) do
        -- This includes all vHosts (MUC components, upload components, ... etc as well!)
        log("debug", "Found vHost: %s", vhostname);
        vhostjson = processHost(vhostname);
        table.insert(vhostsjson, vhostjson);
    end

    return vhostsjson;
end


function jsonResponse()
    -- Query server information only in certain intervals - not on every page request. (Caching)
    local cache_valid = false

    -- Check if cache is valid
    local age = os.difftime(os.time(), cache_updated)
    if age < cache_ttl then
        cache_valid = true
    end


    if cache_valid == true then
        log("debug", "Cache is valid.")
    else
        log("debug", "Cache is invalid. Querying data ...")

        jsonresponse = json({
            api = {
                version = 1,
                ttl = cache_ttl,
                timestamp = os.time()
            },
            software = {
                name = "Prosody",
                version = prosody.version
            },
            location = {
                name = serverinfo_settings.location_name or "[unknown]",
                coordinates = {
                    long = serverinfo_settings.location_coords_long or 0.0,
                    lat = serverinfo_settings.location_coords_lat or 0.0
                }
            },
            admin = {
                name = serverinfo_settings.admin_name or "[unknown]",
                email = serverinfo_settings.admin_email or "[unknown]",
                web = serverinfo_settings.admin_web or "[unknown]"
            },
            vhosts = allvHosts()
        })

        cache_updated = os.time();
    end
end


function httpresponse(event, path)
    jsonResponse()
    -- Ugly workaround: Now remove dummie entries in incoming/outgoing array. Watch the order!
    jsonresponse = string.gsub(jsonresponse, "{\"dummy\":true},", "") -- in case dummy is the only element
    jsonresponse = string.gsub(jsonresponse, "{\"dummy\":true}", "") -- in case dummy element has siblings
    return { status_code = 200, headers = { content_type = "application/json"; }, body = jsonresponse };
end


--
-- Provide HTTP API
--

module:provides("http", {
	default_path = "/serverinfo";
	route = {
		["GET"] = httpresponse;
		["GET /"] = httpresponse;
	};
});
