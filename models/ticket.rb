require_relative("../db/sql_runner")

class Ticket

  attr_reader :id
  attr_accessor :customer_id, :film_id, :screen_id

  def initialize(options)
    @customer_id = options['customer_id'].to_i
    @film_id = options['film_id'].to_i
    @screen_id = options['screen_id'].to_i
    @id = options['id'].to_i if options['id']
  end

  def save()
    sql = "INSERT INTO tickets (customer_id, film_id, screen_id) VALUES ($1, $2, $3) RETURNING id"
    values = [@customer_id, @film_id, @screen_id]
    ticket = SqlRunner.run(sql, values).first
    @id = ticket['id'].to_i
  end

  def Ticket.delete_all()
    sql = "DELETE FROM tickets"
    values = []
    SqlRunner.run(sql, values)
  end

  def Ticket.all()
    sql = "SELECT * FROM tickets"
    values = []
    tickets = SqlRunner.run(sql, values)
    result = tickets.map {|ticket| Ticket.new(ticket)}
    return result
  end

  def delete()
    sql = "DELETE FROM tickets WHERE id = $1"
    values = [@id]
    @id = SqlRunner.run(sql, values)
  end

  def update()
    sql = "UPDATE tickets SET (customer_id, film_id, screen_id) = ($1, $2, $3) WHERE id = $4"
    values = [@customer_id, @film_id, @screen_id, @id]
    SqlRunner.run(sql, values)
  end

  def film()
    sql = "SELECT * FROM films WHERE id = $1"
    values = [@film_id]
    film_data = SqlRunner.run(sql, values).first
    return Film.new(film_data)
  end

  def customer()
    sql = "SELECT * FROM customers WHERE id = $1"
    values = [@customer_id]
    customer_data = SqlRunner.run(sql, values).first
    return Customer.new(customer_data)
  end

  def find_ticket_bought_by_customer()
    sql = "SELECT * FROM tickets WHERE customer_id = $1"
    values = [@customer_id]
    tickets = SqlRunner.run(sql, values)
    return tickets.map { |ticket| Ticket.new(ticket) }.length
  end

  def find_customers_by_film()
    sql = "SELECT * FROM tickets WHERE film_id = $1"
    values = [@film_id]
    customers = SqlRunner.run(sql, values)
    return customers.map { |customer| Customer.new(customer) }.length
  end

end
