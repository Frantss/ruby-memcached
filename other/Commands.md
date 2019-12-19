# Retrival commands

## `get` and `gets`

Shape:

- `get <key>*\r\n`
- `gets <key>*\r\n`

Where:

- `<key>*` means one or more keys separated by a whitespace

## Response

After this command, the client expects zero or more items, each of
which is received as a text line followed by a data block. After all
the items have been transmitted, the server sends the string `END\r\n` to indicate the end of response.

Each item sent by the server looks like this:

`VALUE <key> <flags> <bytes> [<cas unique>]\r\n`  
`<data block>\r\n`

- `<key>` is the key for the item being sent

- `<flags>` is the flags value set by the storage command

- `<bytes>` is the length of the data block to follow, _not_ including
  its delimiting `\r\n`

- `<cas unique>` is a unique 64-bit integer that uniquely identifies
  this specific item.

- `<data block>` is the data for this item.

If some of the keys appearing in a retrieval request are not sent back
by the server in the item list this means that the server does not
hold items with such keys (because they were never stored, or stored
but deleted to make space for more items, or expired, or explicitly
deleted by a client).

# Storage commands

## `set`, `add` and `replace`

Shape:  
`<command name> <key> <flags> <exptime> <bytes> [noreply]\r\n`  
`<data block>\r\n`

Where:

- `<command name>`

  - `set` means "store this data".
  - `add` means "store this data, but only if the server _doesn't_ already hold data for this key".
  - `replace` means "store this data, but only if the server _does_ already hold data for this key".

- `<flags>` is an arbitrary 16-bit unsigned integer (written out in
  decimal) that the server stores along with the data and sends back
  when the item is retrieved. Clients may use this as a bit field to
  store data-specific information; this field is opaque to the server.
  Note that in memcached 1.2.1 and higher, flags may be 32-bits, instead
  of 16, but you might want to restrict yourself to 16 bits for
  compatibility with older versions.
- `<exptime>` is expiration time. If it's 0, the item never expires
  (although it may be deleted from the cache to make place for other
  items). If it's non-zero (either Unix time or offset in seconds from
  current time), it is guaranteed that clients will not be able to
  retrieve this item after the expiration time arrives (measured by
  server time). If a negative value is given the item is immediately
  expired.
- `<bytes>` is the number of bytes in the data block to follow, _not_
  including the delimiting `\r\n`. `<bytes>` may be zero (in which case
  it's followed by an empty data block).
- `noreply` optional parameter instructs the server to not send the
  reply. _NOTE:_ if the request line is malformed, the server can't
  parse `noreply` option reliably. In this case it may send the error
  to the client, and not reading it on the client side will break
  things. Client should construct only valid requests.
- `<data block>` is a chunk of arbitrary 8-bit data of length `<bytes>` from the previous line.

## `append` and `prepend`

Shape:  
`<command name> <key> <bytes> [noreply]\r\n`  
`<data block>\r\n`

Where:

- `<command name>`
  - `append` means "add this data to an existing key after existing data".
  - `prepend` means "add this data to an existing key before existing data".

## `cas`

`cas` is a check and set operation which means "store this data but only if no one else has updated since I last fetched it."

Shape:  
`cas <key> <flags> <exptime> <bytes> <cas unique> [noreply]\r\n`  
`<data block>\r\n`

Where:

- `<cas unique>` is a unique 64-bit value of an existing entry. Clients should use the value returned from the `gets` command when issuing `cas` updates.

## `delete`

Allows to delete a key-value pair.

Shape:  
`delete <key> [noreplay]\r\n`

## `incr` and `decr`

Allows to increment and decrement the data if it is of a numeric type.

Shape:  
`<command name> <key> <value> [noreply]\r\n`

Where:

- `<command name>`
  - `incr` means "increment this data"
  - `decr` means "decrement this data"

Response:

- `<value>\r\n` where `value` is the resulting incrementing or decrementing th data

## Response

- `STORED\r\n`, to indicate success.

- `NOT_STORED\r\n` to indicate the data was not stored, but not because of an error. This normally means that the condition for an `add` or a `replace` command wasn't met.

- `EXISTS\r\n` to indicate that the item you are trying to store with a `cas` command has been modified since you last fetched it.

- `NOT_FOUND\r\n` to indicate that the item you are trying to store with a `cas`, `incr`, `decr` and `delete` command did not exist.

- `DELETED\r\n` to indicate an element has been correctly eliminated.
