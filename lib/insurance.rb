require 'pry'

class Insurance

  attr_accessor :name, :id

  def initialize(name, id)
    @name = name
    @id = id
  end

  def delete_insurance(name)
     DB.exec("DELETE FROM insurance_companies WHERE name = '#{name}'")
  end

  def self.all
    @companies = []
    all_companies = DB.exec('SELECT * FROM insurance_companies;')
    all_companies.each do |companies|
      name = companies['name']
      id = companies['id'].to_i
      @companies << Insurance.new(name, id)
    end
    @companies
  end
end
