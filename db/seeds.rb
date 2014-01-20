# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require 'ffaker'

Department.create name: 'department_1'
Department.create name: 'department_2'
Department.create name: 'department_3'

# create some users

User.create username: 'user_1', password: 'qwer1234', email: 'user_1@example.com'
User.create username: 'user_2', password: 'qwer1234', email: 'user_2@example.com'
User.create username: 'user_3', password: 'qwer1234', email: 'user_3@example.com'

# create issues
25.times do
  Issue.create(
      reporter_name: Faker::Internet.user_name,
      reporter_email: Faker::Internet.email,
      department: Department.limit(1).order('RAND()').first,
      subject: Faker::Lorem.sentence(10),
      description: Faker::Lorem.paragraph(5)
  )
end

