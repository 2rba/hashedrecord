HashedRecord
============

HashedRecord allow to filter in-memory records with ActiveRecord like interface.

example:

We have users with countries
```ruby
users = [
    OpenStruct.new(username: 'bob', country: 'GB'),
    OpenStruct.new(username: 'alise', country: 'UA')
]
```

we might group them into hash and then access by country code as:
```ruby
hash = users.group_by(&:country)
hash['GB']
```

With `HashedRecord`:
```ruby
users = HashedRecord.new([
                     OpenStruct.new(username: 'bob', country: 'GB'),
                     OpenStruct.new(username: 'alise', country: 'UA')
                ])
users.where(country: 'GB')
```

It supports multiple filters:
```ruby
users = HashedRecord.new([
    OpenStruct.new(username: 'bob', country: 'GB', group_id: 1),
    OpenStruct.new(username: 'alise', country: 'UA', group_id: 2)
])
users.where(country: 'GB', group_id: 2)
```

It also supports array as params:
```ruby
users.where(country: 'GB', group_id: [1,2])
```


That allow to make intersections as:
```ruby
orders = HashedRecord.new([
    OpenStruct.new(name: 'ball', user_id: 1, category_id: 3),
    OpenStruct.new(name: 'rocket', user_id: 2, category_id: 3)
])
users = HashedRecord.new([
    OpenStruct.new(id: 1, username: 'bob', country: 'GB'),
    OpenStruct.new(id: 2, username: 'alise', country: 'UA')
])

users.where(id: orders.where(category_id: 3).pluck(:user_id))
```

And difference as:
```ruby
orders = HashedRecord.new([
    OpenStruct.new(name: 'ball', user_id: 1, category_id: 3),
    OpenStruct.new(name: 'rocket', user_id: 2, category_id: 3)
])
users = HashedRecord.new([
    OpenStruct.new(id: 1, username: 'bob', country: 'GB'),
    OpenStruct.new(id: 2, username: 'alise', country: 'UA')
])

users.not(id: orders.where(category_id: 3).pluck(:user_id))
```



### Performance
Under the hood HashedRecord use ruby hashes, and that makes record access as fast as O(1)
