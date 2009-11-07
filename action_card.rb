class ActionCard
  attr_accessor :description, :or_card
  
  def initialize(options = {})
    @description = options.delete(:description) || raise("description is required")
    @resources = get_initial_resources_from_options(options)
        
    @occupation = init_from_options(options, :occupation, true)    
    @rooms = options.delete(:rooms) || {}
    @fixed = options.delete(:fixed) || {}
    @per_turn = options.delete(:per_turn) || {}
    
    @or_card = options.delete(:or)
  end
      
  def allows_occupation?
    @occupation ? true : false
  end
  
  def occupation_price(occupations)
    occupations >= @occupation.size ? @occupation.last : @occupation[occupations]
  end
  
  def allows_building_rooms?(material)
    @rooms.has_key?(material)
  end
  
  def allows_building_multiple_rooms?(material)
    @rooms.has_key?(material) && @rooms[material][:multiple]
  end
  
  def room_price(material)
    raise("doesn't allow that kind of rooms") unless allows_building_rooms?(material)
    
    @rooms[material][:cost]
  end
  
  def act!(options = {})
    return or_card.act! if options[:or]

    resources = @resources.dup

    @fixed.each do |k, v|
      resources[k] += v
    end
    
    @resources.each do |k, v|
      @resources[k] = 0
    end
    
    resources.each do |k, v|
      resources.delete(k) if v == 0
    end
    
    {:resources => resources}
  end
  
  def next_turn!
    @per_turn.each do |k, v|
      @resources[k] = @resources[k].to_i + v
    end
    
    @or_card.next_turn! if @or_card
  end
  
  def add_resources(options)
    options.each do |key, value|
      @resources[key] += value if @resources.has_key?(key)
    end
  end
  
  protected
  def init_from_options(options, name, return_nil = false)
    options.delete(name) || (return_nil ? nil : 0)
  end
  
  def method_missing(sym, *args)
    return @resources[sym] if [:wood, :clay, :stone, :reed, :food, :sheep, :boar, :cattle, :grain, :vegetable].include?(sym)
    super(sym, args)
  end
  
  def get_initial_resources_from_options(options)
    resources = {}
    resources[:wood] = init_from_options(options, :wood)
    resources[:reed] = init_from_options(options, :reed)
    resources[:stone] = init_from_options(options, :stone)
    resources[:clay] = init_from_options(options, :clay)
  
    resources[:food] = init_from_options(options, :food)
  
    resources[:sheep] = init_from_options(options, :sheep)
    resources[:boar] = init_from_options(options, :boar)
    resources[:cattle] = init_from_options(options, :cattle)
  
    resources[:grain] = init_from_options(options, :grain)
    resources[:vegetable] = init_from_options(options, :vegetable)
    
    resources
  end
end