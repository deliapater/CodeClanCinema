require_relative("../db/sql_runner")
class Customer

  attr_reader :id
  attr_accessor :name, :funds

  def initialize(options)
    @name =  options['name']
    @funds = options['funds'].to_i
    @id = options['id'].to_i if options['id']
  end

  def save()
    sql = "INSERT INTO customers (name, funds) VALUES ($1, $2) RETURNING id"
    values = [@name, @funds]
    customer = SqlRunner.run(sql, values).first
    @id = customer['id'].to_i
  end

  def Customer.delete_all()
    sql = "DELETE FROM customers"
    values = []
    SqlRunner.run(sql, values)
  end

  def Customer.all()
    sql = "SELECT * FROM customers"
    values = []
    customers = SqlRunner.run(sql, values)
    result = customers.map {|customer| Customer.new(customer)}
    return result
  end

  def delete()
    sql = "DELETE FROM customers WHERE id = $1"
    values = [@id]
    @id = SqlRunner.run(sql, values)
  end

  def update()
    sql = "UPDATE customers SET (name, funds) = ($1, $2) WHERE id = $3"
    values = [@name, @funds, @id]
    SqlRunner.run(sql, values)
  end

  def films()
    sql = "SELECT films.*
    FROM films
    INNER JOIN tickets
    ON tickets.film_id = films.id
    WHERE customer_id = $1"
    values = [@id]
    film_data = SqlRunner.run(sql, values)
    return film_data.map {|film| Film.new(film)}
  end

  def buy_ticket(film)
    if @funds >= film.price
      @funds -= film.price
      return film.price
    else
      return "Sorry, you don't have enough money"
    end
  end

  # Add any other extensions you think would be great to have at a cinema!
  def customer_count()
    sql = "SELECT COUNT(DISTINCT(tickets.customer_id)) FROM tickets WHERE film_id = $1"
    values = [@id]
    customer_count = SqlRunner.run(sql, values)[0]
    return customer_count['count'].to_i
  end

end
