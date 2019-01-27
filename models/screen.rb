
require_relative("../db/sql_runner")
class Screen

  attr_reader :id
  attr_accessor :film_id, :capacity, :show_time

  def initialize(options)
    @film_id = options['film_id'].to_i
    @capacity = options['capacity'].to_i
    @show_time = options['show_time']
    @id = options['id'].to_i if options['id']
  end

  def save()
    sql = "INSERT INTO screens (film_id, capacity, show_time) VALUES ($1, $2, $3) RETURNING id"
    values = [@film_id, @capacity, @show_time]
    screens = SqlRunner.run(sql, values).first
    @id = screens['id'].to_i
  end


  def Screen.delete_all()
    sql = "DELETE FROM screens"
    values = []
    SqlRunner.run(sql, values)
  end

  def Screen.all()
    sql = "SELECT * FROM screens"
    values = []
    screens = SqlRunner.run(sql, values)
    result = screens.map {|screen| Customer.new(screen)}
    return result
  end

  def delete()
    sql = "DELETE FROM screens WHERE id = $1"
    values = [@id]
    @id = SqlRunner.run(sql, values)
  end

  def update()
    sql = "UPDATE screens SET (film_id, capacity, show_time) = ($1, $2, $3) WHERE id = $4"
    values = [@film_id, @capacity, @show_time, @id]
    SqlRunner.run(sql, values)
  end

  # Limit the available tickets for screenings.
  def limit_tickets()
    sql = "SELECT COUNT(tickets.*) FROM tickets WHERE tickets.screen_id = $1"
    values = [@id]
    tickets_count = SqlRunner.run(sql, values)[0]
    if tickets_count['count'].to_i >= capacity
      return "Sorry, tickets are sold out"
    end
  end

  # Write a method that finds out what is the most popular time (most tickets sold) for a given film
  def most_pop_time()
    sql = "SELECT show_time, COUNT(tickets.*) FROM tickets INNER JOIN screens
    ON tickets.screen_id = screens.id GROUP BY show_time ORDER BY count DESC limit 1"
    values = []
    tickets_count = SqlRunner.run(sql, values)
    return tickets_count.first["show_time"]
  end

end
