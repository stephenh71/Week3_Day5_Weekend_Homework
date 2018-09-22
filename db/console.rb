require('pry')
require_relative('../models/films')
require_relative('../models/customers')
require_relative('../models/screenings')
require_relative('../models/tickets')

customer1 = Customer.new({"name" => "Stephen", "funds" => 50})
customer1.save()
customer2 = Customer.new({"name" => "Laura", "funds" => 10})
customer2.save()

film1 = Film.new({"title" => "Jaws"})
film2 = Film.new({"title" => "Star Wars"})
film3 = Film.new({"title" => "Casablanca"})

film1.save()
film2.save()
film3.save()

screening1 = Screening.new({"capacity" => 100, "film_id" => film1.id, "start_time" => "14:15"})
screening2 = Screening.new({"capacity" => 200, "film_id" => film2.id, "start_time" => "14:15"})
screening3 = Screening.new({"capacity" => 100, "film_id" => film3.id, "start_time" => "17:15"})
screening4 = Screening.new({"capacity" => 100, "film_id" => film3.id, "start_time" => "20:15"})

screening1.save()
screening2.save()
screening3.save()
screening4.save()

ticket1 = Ticket.new({"price" => 5, "customer_id" => customer1.id, "screening_id" => screening1.id})
ticket2 = Ticket.new({"price" => 5, "customer_id" => customer2.id, "screening_id" => screening2.id})
ticket3 = Ticket.new({"price" => 5, "customer_id" => customer1.id, "screening_id" => screening3.id})
ticket4 = Ticket.new({"price" => 5, "customer_id" => customer2.id, "screening_id" => screening3.id})
ticket5 = Ticket.new({"price" => 5, "customer_id" => customer1.id, "screening_id" => screening4.id})

ticket1.save()
ticket2.save()
ticket3.save()
ticket4.save()
ticket5.save()

binding.pry
nil
