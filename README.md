# Fourth

This is the result of going through the minute doc developer guide.

https://developer.minutedock.com/guides/building-a-command-line-interface-for-the-minutedock-api-with-ruby


## Installation

Clone the git repository

    $ git clone https://github.com/carld/fourth.git


Build the gem:

    $ gem build fourth.gemspec


Install it:

    $ gem install --local fourth-0.1.1.gem


And to run the CLI:

    $ fourth


## The reason you are here, to copy entries from one account to another:

Find the account Ids you are interested in:

    $ fourth accounts


Find the project id you are interested in:

    $ fourth projects --account-id=456


Copy entries from one account id to the other, tagging on the destination copy
with the provided project id:

    $ fourth copy --from=123 --to=456 --project-id=789


It will skip duplicates, where the duration, description, and logged_at values
exist for an entry against the destination account.



