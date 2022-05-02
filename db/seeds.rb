# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

unless Group.any?
  Group.create(name: "Основы ruby")
  Group.create(name: "Ruby on Rails")
end

unless Lab.any?
  group = Group.find_by(name: "Основы ruby")
  group.labs.create(title: "Лабораторная работа №1", content_path: "lab1")
  group.labs.create(title: "Лабораторная работа №2", group: group, content_path: "lab2")
  group = Group.find_by(name: "Ruby on Rails")
  group.labs.create(title: "Лабораторная работа №3", group: group, content_path: "lab3")
end

unless Task.any?
  lab = Lab.find_by(title: "Лабораторная №1")
  task1 = lab.tasks.create(title: "Задание 1", content_path: "default")
  task1.task_results.create(total_tests: 200, passed_tests: 200)
  task2 = lab.tasks.create(title: "Задание 2", content_path: "default")
  task2.task_results.create(total_tests: 195, passed_tests: 187)

  lab = Lab.find_by(title: "Лабораторная №2")
  task3 = lab.tasks.create(title: "Задание 1", content_path: "default")
  task3.task_results.create(total_tests: 154, passed_tests: 132)
end