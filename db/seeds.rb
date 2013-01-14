# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
Branch.create({id: 1, title_id: 161, parent_id: 0, leaf_num: 2331, user_id: nil, lang_id: 1, content_at: nil, parent_num: 1, child_num: 1195})

Branch.create({id: 2, title_id: 241, parent_id: 0, leaf_num: 78440, user_id: nil, lang_id: 2, is_ng: true, content_at: "2012-06-25 00:22:30", parent_num: 1, child_num: 43576})

Branch.create({id: 10750, title_id: 163, parent_id: 1, leaf_num: 280, user_id: nil, lang_id: 1, is_ng: true, content_at: nil, parent_num: 1, child_num: 143})

Branch.create({id: 10751, title_id: 1644, parent_id: 1, leaf_num: 249, user_id: nil, lang_id: 1, content_at: "2012-08-22 00:38:09", parent_num: 1, child_num: 122})

Branch.create({id: 10767, title_id: 1660, parent_id: 1, leaf_num: 132, user_id: nil, lang_id: 1, content_at: nil, parent_num: 1, child_num: 41})

Branch.create({id: 10815, title_id: 1701, parent_id: 1, leaf_num: 123, user_id: nil, lang_id: 1, content_at: nil, parent_num: 1, child_num: 28})


Branch.create({id: 14306, title_id: 2892, parent_id: 1, leaf_num: 171, user_id: nil, lang_id: 1, content_at: nil, parent_num: 1, child_num: 125})

Branch.create({id: 14357, title_id: 2902, parent_id: 1, leaf_num: 99, user_id: nil, lang_id: 1, content_at: nil, parent_num: 1, child_num: 68})


Branch.create({id: 16609, title_id: 4237, parent_id: 1, leaf_num: 750, user_id: nil, lang_id: 1, content_at: "2012-07-14 03:18:14", parent_num: 1, child_num: 559})

Branch.create({id: 17496, title_id: 4731, parent_id: 1, leaf_num: 109, user_id: 165, lang_id: 1, content_at: nil, parent_num: 1, child_num: 46})


Branch.create({id: 18374, title_id: 5279, parent_id: 1, leaf_num: 65, user_id: nil, lang_id: 1, content_at: nil, parent_num: 1, child_num: 47})

Branch.create({id: 21451, title_id: 6247, parent_id: 1, leaf_num: 37, user_id: 22, lang_id: 1, content_at: nil, parent_num: 1, child_num: 19})

Title.create({id: 161, name: "English", is_ng: false, branch_id: 1})

Title.create({id: 241, name: "Japanese", is_ng: false, branch_id: 2})

Title.create({id: 163, name: "History", is_ng: false, branch_id: 10750})

Title.create({id: 1644, name: "Geography", is_ng: false, branch_id: 10751})

Title.create({id: 1660, name: "Sports", is_ng: false, branch_id: nil})

Title.create({id: 1701, name: "Life", is_ng: false, branch_id: 10815})

Title.create({id: 2892, name: "Information Technology", is_ng: false, branch_id: 14306})

Title.create({id: 2902, name: "game", is_ng: nil, branch_id: nil})

Title.create({id: 4237, name: "Entertainment", is_ng: nil, branch_id: nil})

Title.create({id: 4731, name: "Creativity", is_ng: nil, branch_id: nil})

Title.create({id: 5279, name: "Politics", is_ng: nil, branch_id: nil})

Title.create({id: 6247, name: "Science", is_ng: nil, branch_id: nil})
