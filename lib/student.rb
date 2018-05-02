class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    # create a new Student object given a row from the database
    s = Student.new
    s.id = row[0]
    s.name = row[1]
    s.grade = row[2]
    s.save
    s
  end

  def self.all
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
    sql = "select * from students"
    rows = DB[:conn].execute(sql)
    rows.map {|row| self.new_from_db(row)}
  end

  def self.find_by_name(name)
    # find the student in the database given a name
    # return a new instance of the Student class
    sql = "select * from students where name is ?"
    row = DB[:conn].execute(sql, name)[0]
    self.new_from_db(row)
  end
  
  def save
    sql = <<-SQL
      INSERT INTO students (name, grade) 
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end
  
  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end

  def self.all_students_in_grade_X(grade)
    sql = "SELECT * from students where grade is ?"
    rows = DB[:conn].execute(sql, grade)
    students = rows.map do |row|
      new_from_db(row)
    end
  end

  def self.count_all_students_in_grade_X(grade)
    sql = "SELECT * from students where grade is ?"
    DB[:conn].execute(sql, grade).count
  end

  def self.count_all_students_in_grade_9
    all_students_in_grade_X(9)
  end

  def self.students_below_12th_grade
    all_students_in_grade_X(9) + all_students_in_grade_X(10) + all_students_in_grade_X(11)
  end

  def self.first_X_students_in_grade_10(x)
    all_students_in_grade_X(10)[0, x]
  end

  def self.first_student_in_grade_10
    first_X_students_in_grade_10(1)[0]
  end

end
