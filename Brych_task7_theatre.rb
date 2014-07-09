class Actor

  def initialize(age, sex, name)
  
    unless sex == 'male' or sex == 'female'
	  raise ArgumentError  
	end
	
	if age < 0 or age > 100
	  raise ArgumentError  
	end
	
	raise ArgumentError if name.nil?
    
	@age, @sex, @name = age, sex.downcase, name
    @casting = []
	
  end
  
  def create_casting?(role)
  
    if @sex == role.sex and role.good_age?(@age)
      @casting << Casting.new(@name + "_" + role.role_name, 1 + rand(5), 1 + rand(200), role)
	  true
	else
	  false
    end
  end
  
  def calculate_casting(juries)
     
    @casting.each do |cast|
      sum = 0
      juries.each do |jur|
        sum += jur.calculate_mark(@age, @sex, cast.text)
      end
      cast.mark = sum / juries.length
    end
  end
  
  def duration
    dur = 0
    @casting.each do |cast|
      dur += cast.time  
    end
    dur
  end
  
  def get_best_role
    max_mark = 0
    role = "No role"
    @casting.each do |cast|
      if max_mark < cast.mark
        max_mark = cast.mark
        role = cast.role.role_name
      end    
    end
    role
  end
end

class Role
  
  attr_reader :sex
  attr_reader :role_name
  
  def initialize(sex, min_age, max_age, role_name)
  
    unless sex == 'male' or sex == 'female'
	  raise ArgumentError  
	end
	
	unless min_age.is_a? Integer and max_age.is_a? Integer and min_age < max_age
	  raise ArgumentError  
	end
	
	raise ArgumentError if role_name.nil?
   
	@sex, @min_age, @max_age, @role_name = sex.downcase, min_age, max_age, role_name.downcase
  end
  
  def good_age?(age)
    if age >=@min_age and age <=@max_age
      true
    else
      false
    end  
  end
  
end

class Jury

  def initialize(sex)
  
    unless sex == 'male' or sex == 'female'
	  raise ArgumentError  
	end

    @sex = sex.downcase
  end
  
  def calculate_mark(actor_age, actor_sex, actor_text)
    
	case @sex
    when "female"
      actor_text < 30 ? 1 + rand(7) : 1 + rand(10)
    when "male"
      if actor_sex == "female" and (18..25) === actor_age
        7 + rand(4)
	  else 
		1 + rand(10)
      end		 
    else 
      raise ArgumentError   
    end 
   
  end
end

class Casting
  
  attr_accessor :mark
  attr_reader :text
  attr_reader :time
  attr_reader :role
  
  def initialize(topic, time, text, role)
    @topic, @time, @text, @role = topic, time, text, role
    mark = 0
  end 
  
end

actors = []
actors << Actor.new( 15, 'male', 'Maz' )

roles = []
roles << Role.new( 'male', 12, 25, 'role1' )

juries = []
juries << Jury.new( 'male' ) << Jury.new('female')

actors[0].create_casting(roles[0])
actors[0].calculate_casting(juries)
puts actors[0].duration
puts actors[0].get_best_role