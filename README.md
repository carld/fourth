# Fourth

This is the result of going through the minute doc developer guide.

https://developer.minutedock.com/guides/building-a-command-line-interface-for-the-minutedock-api-with-ruby

## Installation

Install it yourself as:

    $ gem install fourth

And to run the CLI:

    $ fourth

The reason you are here, to copy entries from one account to another:

    $ fourth copy --from=123 --to=456 --project-id=789

This will copy entries from one account Id to another account Id, setting the project id as provided in the copies.
It will skip duplicates. It detects duplicates where the to account has an entry with the same description and duration.


