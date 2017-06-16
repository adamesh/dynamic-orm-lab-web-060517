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
    sql = <<-SQL
      SELECT * FROM #{self.table_name}
      WHERE #{attr.keys.first.to_s} = '#{attr.values.first.to_s}';
    SQL
    DB[:conn].execute(sql)
  end

  def self.find_by_name(name)
    sql = <<-SQL
      SELECT * FROM #{self.table_name}
      WHERE name = ?;
    SQL
    DB[:conn].execute(sql, name)
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

  def save
    sql = <<-SQL
      INSERT INTO #{self.table_name_for_insert} (#{self.col_names_for_insert})
      VALUES (#{self.values_for_insert});
    SQL
    DB[:conn].execute(sql)
    # Here I set ID
    sql = <<-SQL
      SELECT id FROM #{self.table_name_for_insert}
      ORDER BY id DESC LIMIT 1;
    SQL
    @id = DB[:conn].execute(sql).first["id"]
  end


end
