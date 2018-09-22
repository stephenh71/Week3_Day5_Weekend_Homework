require('pg')
require_relative("../db/sql_runner")

class Screening

  attr_accessor :capacity, :film_id, :start_time
  attr_reader :id

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @capacity = options['capacity'].to_i
    @film_id = options['film_id'].to_i
    @start_time = options['start_time']
  end

  def save()
    sql = "INSERT INTO screenings (capacity, film_id, start_time) VALUES ($1, $2, $3) RETURNING id"
    values = [@capacity, @film_id, @start_time]
    results = SqlRunner.run(sql, values)
    @id = results[0]["id"].to_i
  end

  def update()
    sql = "UPDATE screenings SET (capacity, film_id, start_time) = ($1, $2, $3) WHERE id = $4"
    values = [@capacity, @film_id, @start_time, @id]
    results = SqlRunner.run(sql, values)
  end

  def delete()
    sql = "DELETE FROM screenings WHERE id = $1"
    values = [@id]
    results = SqlRunner.run(sql, values)
  end

  def tickets
    sql = "SELECT tickets.* FROM tickets
    INNER JOIN screenings ON tickets.screening_id = $1
    WHERE screenings.id =$1"
    values = [@id]
    results = SqlRunner.run(sql, values)
    return results.map { |result| Ticket.new(result) }
  end

  def cap_numbers
    tickets = self.tickets
    tickets.length < capacity
    # unfinished
  end

  def self.all()
    sql = "SELECT * FROM screenings"
    results = SqlRunner.run(sql)
    return results.map { |result|Screening.new(result)}
  end

  def self.delete_all()
    sql = "DELETE FROM screenings"
    SqlRunner.run(sql)
  end

  def self.find(id)
    sql = "SELECT * FROM screenings WHERE id = $1"
    values = [id]
    results = SqlRunner.run(sql, values)
    return Screening.new(results[0])
  end

end
