# mod_serverinfo

A Prosody module for server information - currently used by https://network.trashserver.net for data gathering.

---

This Prosody module provides server information (Number of registered users, number of online users, connected servers) on the Prosody HTTP-port. Access JSON data via

    <prosodyserver>:<httpport>/serverinfo


## Install

Clone this Git repository into your Prosody modules directory and enable the module in your configuration by adding "serverinfo" to your modules list. 
