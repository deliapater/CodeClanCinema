require('pry')
require_relative('models/customer')
require_relative('models/film')
require_relative('models/ticket')
require_relative('models/screen')

Ticket.delete_all()
Film.delete_all()
Customer.delete_all()
Screen.delete_all()

customer1 = Customer.new({ 'name' => 'Pascaline', 'funds' => '50'})
customer1.save()
customer1.funds = '20'
customer1.update()


customer2 = Customer.new({ 'name' => 'Nathaly', 'funds' => '60'})
customer2.save()


customer3 = Customer.new({ 'name' => 'Ray', 'funds' => '5'})
customer3.save()

film1 = Film.new({ 'title' => 'The Intouchables', 'price' => '10'})
film1.save()
film1.price = '9'
film1.update()

film2 = Film.new({ 'title' => 'The Invisible Guest', 'price' => '10'})
film2.save()
customer2.buy_ticket(film2)

film3 = Film.new({ 'title' => 'Bird Box', 'price' => '10'})
film3.save()
film3.delete()


screen1 = Screen.new({ 'film_id' => film1.id, 'capacity' => '0', 'show_time' => '20:00'})
screen1.save()

screen2 = Screen.new({ 'film_id' => film2.id, 'capacity' => '5', 'show_time' => '20:00'})
screen2.save()

screen3 = Screen.new({ 'film_id' => film1.id, 'capacity' => '10', 'show_time' => '23:00'})
screen3.save()
screen3.show_time = '22:00'
screen3.update()

ticket1 = Ticket.new({ 'customer_id' => customer1.id, 'film_id' => film1.id, 'screen_id' => screen1.id})
ticket1.save()

ticket2 = Ticket.new({ 'customer_id' => customer3.id, 'film_id' => film1.id, 'screen_id' => screen1.id})
ticket2.save()
ticket2.film_id = film2.id
ticket2.update()

ticket3 = Ticket.new({ 'customer_id' => customer2.id, 'film_id' => film2.id, 'screen_id' => screen2.id})
ticket3.save()

ticket1.find_ticket_bought_by_customer()
ticket1.find_customers_by_film()


customer3.buy_ticket(film2)


screen1.most_pop_time()

binding.pry
nil
