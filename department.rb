require './employee'
require 'sqlite3'

class Department < ActiveRecord::Base
  #attr_reader :name, :staff, :review

  # def initialize(department_name)
  #   @name = department_name
  #   @staff = []
  # end

  def add_employee(new_employee)
    new_employee.department_id = self.id
    new_employee.save
  end

  def department_salary
    a = Employee.where(department_id: self.id).to_a
    a.reduce(0.0) {|sum, e| sum + e.salary}
  end

  def department_raise(alloted_amount)
    a = Employee.where(department_id: self.id).to_a
    raise_eligible = a.select {|e| yield(e)}
    amount = alloted_amount / raise_eligible.length
    raise_eligible.each {|e| e.raise_by_amount(amount)}
  end

  def employee_count
    employees_in_department = Employee.where(department_id: self.id).to_a
    employees_in_department.count
  end

  def least_paid
    employees_in_department = Employee.where(department_id: self.id).to_a
    salary_low_to_high = employees_in_department.sort_by { |el| el.salary }
    salary_low_to_high[0].name
  end

  def alphabetize
    employees_in_department = Employee.where(department_id: self.id).to_a
    name_list_a_to_z = employees_in_department.sort_by { |el| el.name }
    name_list_a_to_z
  end

  def average_salary
    department_salary / employee_count
  end

  def above_average_salary
    employees_in_department = Employee.where(department_id: self.id).to_a
    above_averages = []
    above_averages = employees_in_department.map{|el| el.name if (el.salary > average_salary)}.compact
    above_averages.join(", ")
  end

  def palindrome?(str)
    str == str.reverse
  end

  def palindrome_in_department
    employees_in_department = Employee.where(department_id: self.id).to_a
    above_averages = []
    above_averages = employees_in_department.map{|el| el.name if (palindrome?(el.name.downcase))}.compact
    above_averages.join(", ")
  end

  def department_size
    Employee.where(department_id: self.id).size
  end

  def self.most_employees
    a = Department.all.max_by { |dept| dept.department_size }
    a.name
  end

  # def self.move_all_employees
  #   a = Department.all.max_by { |dept| dept.department_size }
  #   a.name
  # end

end
