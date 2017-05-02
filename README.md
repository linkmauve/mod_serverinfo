# mod_serverinfo

A Prosody module for server information - currently used by https://network.trashserver.net for data gathering.

---

This Prosody module provides server information (Number of registered users, number of online users, connected servers) on the Prosody HTTP-port. Access JSON data via

    http://<prosodyserver>:<httpport>/serverinfo


## Example JSON output

    {
        "admin": {
            "web": "https://trashserver.net",
            "name": "Thomas Leister",
            "email": "xmpp@trashserver.net"
        },
        "api": {
            "version": 1
        },
        "location": {
            "name": "Servercow",
            "coordinates": {
                "long": 666,
                "lat": 42
            }
        },
        "software": {
            "name": "Prosody",
            "version": "0.9.12"
        },
        "vhosts": [
        {
            "connections": {
                "s2s": {
                    "incoming": {},
                    "outgoing": {}
                },
            "c2s": {
                "count": 0
            }
          },
          "name": "uploads.security-enforced.de",
          "users_connected": 0
        },
        {
              "connections": {
                  "s2s": {
                  "incoming": [
                        { "from": "trashserver.net" },
                        { "from": "jabber.de" }
                  ],
                  "outgoing": [
                        { "to": "trashserver.net" },
                        { "to": "jabber.de" }
                  ]
                },
                "c2s": {
                    "count": 2
                }
              },
              "name": "security-enforced.de",
              "users_connected": 1
        },
        {
            "connections": {
                "s2s": {
                    "incoming": {},
                    "outgoing": {}
                },
                "c2s": {
                    "count": 0
                }
            },
            "name": "conference.security-enforced.de",
            "users_connected": 0
        }
        ]
    }


## Install

Clone this Git repository into your Prosody modules directory and enable the module in your configuration by adding "serverinfo" to your modules list. Then restart Prosody to apply the changes.


## Configure

Configuration options in prosody.cfg.lua:

    serverinfo = {
        admin_name = "Thomas Leister";
        admin_email = "xmpp@trashserver.net";
        admin_web = "https://trashserver.net";

        location_name = "Servercow";
        location_coords_long = 666;
        location_coords_lat = 42;
    }
