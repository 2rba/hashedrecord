HashedRecord
============

HashedRecord allow to filter in-memory records with ActiveRecord like interface.

example:

We have users with countries
we group them into hash and then access by country code as:
``` ruby
users = [
    { username: 'bob', country: 'GB' },
    { username: 'alise', country: 'UA' }
]

hash = users.group_by {|r| r[:country] }
hash['GB'] # => [{:username=>"bob", :country=>"GB"}]
```

With `HashedRecord`:
``` ruby
users = HashedRecord.new([
                     { username: 'bob', country: 'GB', group_id: 1 },
                     { username: 'alise', country: 'UA', group_id: 1 },
                     { username: 'serg', country: 'UA', group_id: 2 }
])

users.where(country: 'GB') # => [{:username=>"bob", :country=>"GB", :group_id=>1}]
```

It supports multiple filters:
``` ruby
users.where(country: 'UA', group_id: 2) # => [{:username=>"serg", :country=>"UA", :group_id=>2}]
```

It supports array of ids as params:
``` ruby
users.where(country: 'UA', group_id: [1,2]) # => [{:username=>"alise", :country=>"UA", :group_id=>1}, {:username=>"serg", :country=>"UA", :group_id=>2}]
```

It supports negative filters:
``` ruby
users.not(country: 'UA') # => [{:username=>"bob", :country=>"GB", :group_id=>1}]
```

It supports chained filters:
``` ruby
users.where(group_id: 1).not(country: 'UA') # => [{:username=>"bob", :country=>"GB", :group_id=>1}]
```

That allow to make intersections as:
``` ruby
orders = HashedRecord.new([
    { name: 'ball', user_id: 1, category_id: 3 },
    { name: 'rocket', user_id: 1, category_id: 3 }
])
users = HashedRecord.new([
    { id: 1, username: 'bob', country: 'GB' },
    { id: 2, username: 'alise', country: 'UA'}
])

user_ids = orders.where(category_id: 3).map{ |r| r[:user_id] }
users.where(id: user_ids) # => [{:id=>1, :username=>"bob", :country=>"GB"}]
```

And difference as:
``` ruby
orders = HashedRecord.new([
    { name: 'ball', user_id: 2, category_id: 3 },
    { name: 'rocket', user_id: 2, category_id: 3 }
])
users = HashedRecord.new([
    { id: 1, username: 'bob', country: 'GB' },
    { id: 2, username: 'alise', country: 'UA'}
])

user_ids = orders.where(category_id: 3).map{ |r| r[:user_id] }
users.not(id: user_ids) # => [{:id=>2, :username=>"alise", :country=>"UA"}]
```

## Records data types

It works hashes with string as key:
``` ruby
users = HashedRecord.new([
                     { 'username' => 'bob', 'country' => 'GB' },
                     { 'username' => 'alise', 'country' => 'UA' }
                ])
users.where(country: 'GB') # => [{"username"=>"bob", "country"=>"GB"}]
```

It works with objects:
``` ruby
users = HashedRecord.new([
                     OpenStruct.new(username: 'bob', country: 'GB'),
                     OpenStruct.new(username: 'alise', country: 'UA')
                ])
users.where(country: 'GB') # => [#<OpenStruct username="bob", country="GB">, #<OpenStruct username="alise", country="UA">]
```

It allow to specify custom access method:
``` ruby
users = HashedRecord.new([
                     { attributes: { username: 'bob', country: 'GB' } },
                     { attributes: { username: 'alise', country: 'UA' } }
                ], access_method: ->(record, key) { record[:attributes].send(:[], key) })
users.where(country: 'GB') # => [{:attributes=>{:username=>"bob", :country=>"GB"}}]
```

## Performance
Under the hood HashedRecord use ruby hashes, and that makes record access as fast as O(1)

## Activerecord and Enumerable
You can extend Enumerable as:
``` ruby
module Enumerable
  def to_hashed
     HashedRecord.new(to_a)
  end
end
```

That allow to filter as:
``` ruby
users = [
  { 'username' => 'bob', 'country' => 'GB' },
  { 'username' => 'alise', 'country' => 'UA' }
]
users.to_hashed.where(username: 'bob') # => [{:username=>"bob", :country=>"GB"}]
```

And handle activerecord relation as:
``` ruby
Users.where(country: 'GB').to_hashed.where(group_id: [...])
```

## Install
``` terminal
gem install hashedrecord
```

or in your **Gemfile**

``` ruby
gem 'hashedrecord'
```
