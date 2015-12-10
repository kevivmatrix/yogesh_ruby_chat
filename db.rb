require "sequel"
require "mysql"


db = Sequel.connect('mysql://root:root@localhost/test')

#db.create_table :items do
#  primary_key :id
#  String :name
# Float :price
#end


# create a dataset from the items table
items = db[:items]

# populate the table
items.insert(:name => 'abc', :price => rand * 100)
items.insert(:name => 'def', :price => rand * 100)
items.insert(:name => 'ghi', :price => rand * 100)


puts "Item count: #{items.count}"

# print out the average price
puts "The average price is: #{items.avg(:price)}"




