require('pg')
require_relative("../db/sql_runner")

class Customer

  attr_accessor :name, :funds
  attr_reader :id

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @name = options['name']
    @funds = options['funds']
  end

  def save()
      sql = "INSERT INTO customers (name, funds) VALUES ($1, $2) RETURNING id"
      values = [@name, @funds]
      results = SqlRunner.run(sql, values).first
      @id = results['id'].to_i
    end

    def update()
      sql = "UPDATE customers SET (name, funds) = ($1, $2) WHERE id = $3"
      values = [@name, @funds, @id]
      results = SqlRunner.run(sql, values)
    end

    def delete()
      sql = "DELETE FROM customers WHERE id = $1"
      values = [@id]
      results = SqlRunner.run(sql, values)
    end

    def films
      sql = "SELECT films.* FROM films

      INNER JOIN screenings ON screenings.film_id = films.id
      INNER JOIN tickets ON tickets.screening_id = screenings.id
      INNER JOIN customers ON tickets.customer_id = customers.id

      WHERE customers.id = $1"

      values = [@id]

      results = SqlRunner.run(sql, values)
      return results.map { |result| Film.new( result ) }
    end

    def tickets
      sql = "SELECT tickets.* FROM tickets
      INNER JOIN customers ON tickets.customer_id = $1
      WHERE customers.id =$1"

      values = [@id]

      results = SqlRunner.run(sql, values)
      return results.map { |result| Ticket.new(result) }
    end

    def pay_for_tickets
      tickets = self.tickets
      ticket_price = tickets.map {|ticket| ticket.price}
      total_cost = ticket_price.sum
      return @funds - total_cost
    end

    def total_tickets_bought
      tickets = self.tickets
      return tickets.length
    end

    def self.all()
      sql = "SELECT * FROM customers"
      results = SqlRunner.run(sql)
      return results.map { |result|Customer.new(result)}
    end

    def self.delete_all()
      sql = "DELETE FROM customers"
      SqlRunner.run(sql)
    end

    def self.find(id)
      sql = "SELECT * FROM customers WHERE id = $1"
      values = [id]
      results = SqlRunner.run(sql, values)
      return Customer.new(results[0])
    end

end
