require_relative "../config/environment.rb"
require 'active_support/inflector'

class InteractiveRecord

  def self.column_names
    sql = <<-SQL
      PRAGMA table_info(students);
    SQL
    column_info = DB[:conn].execute(sql)
    column_names = []
    column_names = column_info.map {|column| column["name"]}
    column_names.compact
  end

  def self.table_name
    table_name = self.to_s.downcase + 's'
  end

  def self.find_by(attr)
    #accounts for when an attribute value is an integer
    #executes the SQL to find a row by the attribute passed
    #into the method

    sql = <<-SQL
      SELECT * FROM #{self.table_name}
      WHERE ? = ?;
    SQL
    #NEEDS SAVE FIRST FOR TEST
  end

  def col_names_for_insert
    col_names = self.class.column_names.delete_if {|col| col == "id"}
    col_names.join(', ')
  end

  def values_for_insert
    values = []
    self.class.column_names.each do |col_name|
      values << "'#{send(col_name)}'" unless send(col_name).nil?
    end
    values.join(', ')
  end

  def table_name_for_insert
    self.class.table_name
  end








end
