# Overview

Feature flags are organized using these models:
* Silos
* Releases
* Features
* Flags

Each flag represents whether a feature is enabled (on) or disabled (off) for a given release.

Flags can be visualized like this:

Feature  | release-4.22 | release-4.21 | release-4.20
-------- | ------------ | ------------ | ------------
SparklingCursorTrails | off | off | off
AutoplayMidiMusic | ON | off | off
MarqueeTitleText | ON | ON | ON

Each silo is assigned a release. More than one silo can be on the same release.

Silo | Release
---- | -------
qa | release-4.22
staging | release-4.21
hotfix | release-4.20
production | release-4.20

The selected release determines which features are enabled on that silo.

# Authentication and Logging

Authentication is performed against Active Directory and is maintained across API requests via JSON Web Tokens.

Authentication is required to create, update, or destroy records. It is _not_ required to read any records.

Changes to any model are logged as a Change record. Each Change records stores:
* the action performed
* the record that was changed
* the diff of changed attributes
* the user whose performed the change

# Environment Variables

The following environment variables are required for this app to run.

A `.env` file may be placed in the project root to define these values.

Variable | Description
-------- | -----------
`VFEATURES_SECRET_KEY` | The key used to generate JSON Web Tokens
`VFEATURES_LDAP_HOST` | The IP address of the Active Directory domain controller.
`VFEATURES_LDAP_PORT` | The port of the Active Directory domain controller.

# API Endpoints

Verb | Path | Description | Parameters
---- | ---- | ----------- | ----------
`POST`   | `/login`        | Authenticate against Active Directory. If successful, returns a JSON Web Token.
`DELETE` | `/logout`       | End the user session by destroying the JSON Web Token.
`GET`    | `/silos`        | Returns a list of every silo.
`POST`   | `/silos`        | Create a new silo.
`GET`    | `/silos/:id`    | Returns the details of a silo.
`PUT`    | `/silos/:id`    | Edit a silo.
`DELETE` | `/silos/:id`    | Delete a silo.
`GET`    | `/features`     | Returns a list of every feature.
`POST`   | `/features`     | Create a new feature.
`GET`    | `/features/:id` | Returns the details of a feature and its flags.
`PUT`    | `/features/:id` | Edit a feature.
`DELETE` | `/features/:id` | Delete a feature.
`GET`    | `/releases`     | Returns a list of every release.
`POST`   | `/releases`     | Create a new release.
`GET`    | `/releases/:id` | Returns the details of a release and its flags.
`PUT`    | `/releases/:id` | Edit a release.
`DELETE` | `/releases/:id` | Delete a release.
`GET`    | `/flags/:id`    | Returns the details of a flag.
`PUT`    | `/flags/:id`    | Enable or disable a flag.
`GET`    | `/changes`      | Returns a paginated list of every logged change. Parameters may be used to filter the list.
`GET`    | `/users`        | Returns a list of every user that has logged in at least once.
