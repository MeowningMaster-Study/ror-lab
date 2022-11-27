class StudentsController < ApplicationController
  def index
    @students = Student.all

    @t1 = t1(@students)
    @t2 = t2(@students)
    @t3 = t3(@students)
    @t4 = t4(@students)
  end

  def show
    @student = Student.find(params[:id])
  end

  def new
    @student = Student.new
  end

  def create
    @student = Student.new(student_params)

    if @student.save
      redirect_to @student
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @student = Student.find(params[:id])
  end

  def update
    @student = Student.find(params[:id])

    if @student.update(student_params)
      redirect_to @student
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @student = Student.find(params[:id])
    @student.destroy

    redirect_to root_path, status: :see_other
  end

  private
    def student_params
      params.require(:student).permit(:name, :surname, :patronymic, :sex, :age, :course)
    end

  # Номер курса з найбільшим процентом чоловіків
  def t1(arr)
    # Hash<course, [M, F]>
    stats = Hash.new

    arr.each do |s|
      course = s.course
      i = s.sex == "M" ? 0 : 1
      unless stats.has_key?(course)
        stats[course] = [0, 0]
      end
      stats[course][i] += 1
    end

    max_course = -Float::INFINITY
    max_part = -Float::INFINITY
    stats.each_pair do |course, counts|
      m, f  = counts
      part = m.to_f / (m + f)
      if part > max_part
        max_course = course
        max_part = part
      end
    end

    max_course
  end

  # Найрозповсюдженіші чоловічі та жіночі імена
  def t2(arr)
    # [M: Hash<name, count>, F: Hash<name, count>]
    stats = [Hash.new, Hash.new]

    arr.each do |s|
      name = s.name
      i = s.sex == "M" ? 0 : 1
      stats_sex = stats[i]
      unless stats_sex.has_key?(name)
        stats_sex[name] = 0
      end
      stats_sex[name] += 1
    end

    stats.map do |stats_sex|
      max_name = "None"
      max_count = -Float::INFINITY
      stats_sex.each_pair do |name, count|
        if count > max_count
          max_name = name
          max_count = count
        end
      end
      max_name
    end
  end

  # Прізвища в алфавітному порядку
  def t3(arr)
    arr.map{|x| x.surname }.sort
  end

  # Ініціали студенток з найрозповсюдженішим віком
  def t4(arr)
    # Hash<age, count>
    stats = Hash.new

    arr.each do |s|
      if s.sex == "F"
        age = s.age
        unless stats.has_key?(age)
          stats[age] = 0
        end
        stats[age] += 1
      end
    end

    age_mode = -Float::INFINITY
    max_count = -Float::INFINITY
    stats.each_pair do |age, count|
      if count > max_count
        max_count = count
        age_mode = age
      end
    end

    arr.select { |s| s.sex == "F" && s.age == age_mode }
       .map{ |s| "%s %s. %s." % [s.surname, s.name[0], s.patronymic[0]] }
  end
end
