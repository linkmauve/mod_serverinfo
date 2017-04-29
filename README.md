# mod_serverinfo

A Prosody module for server information - currently used by https://network.trashserver.net for data gathering.

---

This Prosody module provides server information (Number of registered users, number of online users, connected servers) on the Prosody HTTP-port. Access JSON data via

    http://<prosodyserver>:<httpport>/serverinfo


## Example JSON output

    {
        "servers": {
            "incoming": [
                "yax.im",
                "fusselkater.org",
                "skweez.net",
                "blah.im",
                "chat.c3d2.de"
            ],
            "outgoing": [
                "engelbracht.de",
                "straubis.org",
                "xmppnet.de",
                "israuorflix.tk"
            ]
        },
        "users": {
            "connected": 697,
            "registered": 3650
        }
    }


## Install

Clone this Git repository into your Prosody modules directory and enable the module in your configuration by adding "serverinfo" to your modules list. Then restart Prosody to apply the changes.


## Known issues

* Module does not work with LDAP as a user backend.
