require('pg')
require_relative("../db/sql_runner")

class Ticket

  attr_accessor :price, :customer_id, :screening_id
  attr_reader :id

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @price = options['price'].to_i
    @customer_id = options['customer_id'].to_i
    @screening_id = options['screening_id'].to_i
  end

  def save()
      sql = "INSERT INTO tickets (price, customer_id, screening_id) VALUES ($1, $2, $3) RETURNING id"
      values = [@price, @customer_id, @screening_id]
      results = SqlRunner.run(sql, values).first
      @id = results["id"].to_i
    end

    def update()
      sql = "UPDATE tickets SET (price, customer_id, screening_id) = ($1, $2, $3) WHERE id = $4"
      values = [@price, @customer_id, @screening_id, @id]
      results = SqlRunner.run(sql, values)
    end

    def delete()
      sql = "DELETE FROM tickets WHERE id = $1"
      values = [@id]
      results = SqlRunner.run(sql, values)
    end

    def self.all()
      sql = "SELECT * FROM tickets"
      results = SqlRunner.run(sql)
      return results.map { |result|Ticket.new(result)}
    end

    def self.delete_all()
      sql = "DELETE FROM tickets"
      SqlRunner.run(sql)
    end

    def self.find(id)
      sql = "SELECT * FROM tickets WHERE id = $1"
      values = [id]
      results = SqlRunner.run(sql, values)
      return Ticket.new(results[0])
    end





end
