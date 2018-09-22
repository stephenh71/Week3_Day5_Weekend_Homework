require('pg')
require_relative("../db/sql_runner")

class Film

  attr_accessor :title
  attr_reader :id

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @title = options['title']
  end

  def save()
      sql = "INSERT INTO films (title) VALUES ($1) RETURNING id"
      values = [@title]
      results = SqlRunner.run(sql, values)
      @id = results[0]["id"].to_i
    end

    def update()
      sql = "UPDATE films SET title = $1 WHERE id = $2"
      values = [@title, @id]
      results = SqlRunner.run(sql, values)
    end

    def delete()
      sql = "DELETE FROM films WHERE id = $1"
      values = [@id]
      results = SqlRunner.run(sql, values)
    end

    def customers
      sql = "SELECT customers.* FROM customers

      INNER JOIN tickets ON tickets.customer_id = customers.id
      INNER JOIN screenings ON screenings.id = tickets.screening_id
      INNER JOIN films ON films.id = screenings.film_id

      WHERE films.id = $1"

      values = [@id]

      results = SqlRunner.run(sql, values)
      return results.map { |result| Customer.new( result ) }
    end

    def total_customers
      customers = self.customers
      return customers.length
    end

    def tickets
      sql = "SELECT tickets.* FROM tickets
      INNER JOIN screenings ON screenings.id = tickets.screening_id
      INNER JOIN tickets films ON films.id = screenings.film_id

      WHERE films.id = $1"

      values = [@id]

      results = SqlRunner.run(sql, values)
      return results.map { |result| Ticket.new( result ) }
    end

    def screening_with_most_tickets
      tickets = self.tickets
      screenings = tickets.map {|ticket| ticket.screening_id}
      unique = screenings.uniq
      result={}
        for screen in unique
           result[screen] = screenings.count(screen)
        end
      most_popular = result.key(result.values.max)
      sql = "SELECT * FROM screenings WHERE id = #{most_popular}"
      results = SqlRunner.run(sql)
      return results.map { |result|Screening.new(result)}
    end

    def self.all()
      sql = "SELECT * FROM films"
      results = SqlRunner.run(sql)
      return results.map { |result|Film.new(result)}
    end

    def self.delete_all()
      sql = "DELETE FROM films"
      SqlRunner.run(sql)
    end

    def self.find(id)
      sql = "SELECT * FROM films WHERE id = $1"
      values = [id]
      results = SqlRunner.run(sql, values)
      return Film.new(results[0])
    end

end
