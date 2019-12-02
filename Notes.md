# Expiration time

Some commands involve a client sending some kind of expiration time
(relative to an item or to an operation requested by the client) to
the server. In all such cases, the actual value sent may either be
Unix time (number of seconds since January 1, 1970, as a 32-bit
value), or a number of seconds starting from current time. In the
latter case, this number of seconds may not exceed 60*60*24\*30 (number
of seconds in 30 days); if the number sent by a client is larger than
that, the server will consider it to be real Unix time value rather
than an offset from current time.

Note that a TTL of 1 will sometimes immediately expire. Time is internally
updated on second boundaries, which makes expiration time roughly +/- 1s.
This more proportionally affects very low TTL's.

# Errors

Each command sent by a client may be answered with an error string
from the server. These error strings come in three types:

- `ERROR\r\n`

  means the client sent a nonexistent command name.

- `CLIENT_ERROR <error>\r\n`

  means some sort of client error in the input line, i.e. the input
  doesn't conform to the protocol in some way. `<error>` is a
  human-readable error string.

- `SERVER_ERROR <error>\r\n`

  means some sort of server error prevents the server from carrying
  out the command. `<error>` is a human-readable error string. In cases
  of severe server errors, which make it impossible to continue
  serving the client (this shouldn't normally happen), the server will
  close the connection after sending the error line. This is the only
  case in which the server closes a connection to a client.

# Authentication

Optional username/password token authentication (see -Y option). Used by
sending a fake "set" command with any key:

`set <key> <flags> <exptime> <bytes>\r\n`

`username password\r\n`

key, flags, and exptime are ignored for authentication. Bytes is the length
of the username/password payload.

- `STORED\r\n` indicates success. After this point any command should work normally.

- `CLIENT_ERROR [message]\r\n` will be returned if authentication fails for any reason.
