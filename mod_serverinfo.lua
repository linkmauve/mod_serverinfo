--
-- mod_serverinfo by Thomas Leister <thomas.leister@mailbox.org>
--


module:depends("http");

local json = require "util.json".encode_ordered;
local hosts = prosody.hosts;



function count_users()
    users = {}
    local users_connected = 0
    local users_registered = 0


    for host, _ in pairs(hosts) do
        if hosts[host].users and hosts[host].users.users then
            for _ in hosts[host].users:users() do
                users_registered = users_registered + 1
            end
        end
    end


    for hostname, host_session in pairs(hosts) do
		if host_session.sessions then
			for username in pairs(host_session.sessions) do
				users_connected = users_connected + 1
			end
		end
	end

    users["connected"] = users_connected
    users["registered"] = users_registered

    return users
end


function count_servers_connected()
    servers = {}
    servers_outgoing = {}
    servers_incoming = {}
    servers["outgoing"] = servers_outgoing
    servers["incoming"] = servers_incoming

    for host, _ in pairs(hosts) do
        for _, value in pairs(hosts[host].s2sout) do
            if servers_outgoing[value.to_host] == nil then
                table.insert(servers_outgoing, value.to_host)
            end
        end
    end

    for key, _ in pairs(prosody.incoming_s2s) do
        if servers_incoming[key.from_host] == nil then
            table.insert(servers_incoming, key.from_host)
        end
    end

    return servers;
end



function httpresponse(event, path)
    local body = json({
        servers = count_servers_connected(),
        users = count_users()
    })

    return { status_code = 200, headers = { content_type = "application/json"; }, body = body };
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
