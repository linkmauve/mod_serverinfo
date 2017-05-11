# mod_serverinfo

This Prosody module outputs JSON-formatted server information via HTTP.

*Currently used by https://xmpp-network.info for data gathering. Feel free to use this module for your own project.*

---

This Prosody module provides server information (Number of online users, connected servers, general server and admin information) via the Prosody HTTP-port. You can access the JSON formatted data via

    http://myserver.tld:<httpport>/serverinfo


## Example JSON output

    {
      "admin": {
        "web": "https://myserver.tld",
        "email": "xmpp@myserver.tld",
        "name": "John Doe",
        "xmpp": "admin@myserver.tld"
      },
      "api": {
        "timestamp": 1494489240,
        "version": 1,
        "ttl": 60
      },
      "location": {
        "name": "Superhoster",
        "coordinates": {
          "long": 666,
          "lat": 42
        }
      },
      "vhosts": [
        {
          "connections": {
            "s2s": {
              "incoming": [
                {
                  "from": "mailbox.org"
                },
                {
                  "from": "push.siacs.eu"
                },
                {
                  "from": "jabber.de"
                },
                {
                  "from": "trashserver.net"
                }
              ],
              "outgoing": [
                {
                  "to": "push.siacs.eu"
                },
                {
                  "to": "mailbox.org"
                },
                {
                  "to": "trashserver.net"
                },
                {
                  "to": "jabber.de"
                }
              ]
            },
            "c2s": {
              "count": 2
            }
          },
          "name": "myserver.tld",
          "users_connected": 1
        }
      ],
      "components": [
        {
          "name": "uploads.myserver.tld",
          "connections": {
            "s2s": {
              "incoming": [],
              "outgoing": []
            }
          }
        },
        {
          "name": "conference.myserver.tld",
          "connections": {
            "s2s": {
              "incoming": [],
              "outgoing": []
            }
          }
        }
      ],
      "software": {
        "name": "Prosody",
        "version": "0.9.12"
      }
    }


## Install

Clone this Git repository into your Prosody modules directory and enable the module in your configuration by adding "serverinfo" to your modules list. Then restart Prosody to apply the changes.


## Configure

Available configuration options for ```prosody.cfg.lua```:

    serverinfo = {
        admin_name = "John Doe";
        admin_email = "xmpp@myserver.tld";
        admin_xmpp = "admin@myserver.tld"
        admin_web = "https://myserver.tld";

        location_name = "Superhoster";
        location_coords_long = 666;
        location_coords_lat = 42;

        cache_ttl = 60;
    }

**Make sure you place this config section before the first VirtualHost declaration (into the global section)!**
