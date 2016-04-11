class DropFriendships < ActiveRecord::Migration
   #this migration is getting rid of an old friendships table that i made by 
   #mistake. how can i get rid of it?

   def change
      drop_table :friendships
   end
end
