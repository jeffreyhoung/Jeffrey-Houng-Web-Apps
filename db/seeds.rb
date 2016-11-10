Task.delete_all
List.delete_all
#Task.reset_autoincrement
#List.reset_autoincrement
#ActiveRecord::Base.connection.execute("ALTER TABLE tasks AUTO_INCREMENT = 1;")
#ActiveRecord::Base.connection.execute("ALTER TABLE lists AUTO_INCREMENT = 1;")

List.create!([{ name: "My First List" } ])
List.create!([{ name: "My Second List" } ])

Task.create!([{ name: "Example task", list_id: 1 } ])
Task.create!([{ name: "Example 2", list_id: 1 } ])
Task.create!([{ name: "Example 3", list_id: 2 } ])
Task.create!([{ name: "Example 4", list_id: 1 } ])
Task.create!([{ name: "Example 5", list_id: 2 } ])
Task.create!([{ name: "Example 6", list_id: 2 } ])

