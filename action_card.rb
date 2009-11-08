class ActionCard
  attr_accessor :description, :or_card, :and_or_card, :after_card, :and_card
  
  def initialize(options = {})
    @description = options.delete(:description) || raise("description is required")
    @resources = get_initial_resources_from_options(options)
    @actions = get_actions_from_options(options)

    @fixed = options.delete(:fixed) || {}
    @per_turn = options.delete(:per_turn) || {}
    
    @and_card = options.delete(:and)
    @or_card = options.delete(:or)
    @and_or_card = options.delete(:and_or)
    @after_card = options.delete(:after)
  end
      
  def allows_occupation?
    @actions[:occupation] ? true : false
  end
  
  def occupation_price(occupations)
    occupations >= @actions[:occupation].size ? @actions[:occupation].last : @actions[:occupation][occupations]
  end
  
  def allows_building_rooms?(material)
    @actions[:rooms] && @actions[:rooms].has_key?(material)
  end
  
  def allows_building_multiple_rooms?(material)
    @actions[:rooms] && @actions[:rooms].has_key?(material) && @actions[:rooms][material][:multiple]
  end
  
  def room_price(material)
    raise("doesn't allow that kind of rooms") unless allows_building_rooms?(material)
    
    @actions[:rooms][material][:cost]
  end
  
  def act!(options = {})
    return @or_card.act! if options[:or]
    return @and_or_card.act! if options[:and_or] == :or
    
    result = {
      :resources => act_on_resources!(options),
      :required_actions => act_on_actions!
    }
    
    result[:allowed_actions] = and_or_card.act_on_actions!.merge(result.delete(:required_actions)) if and_or_card
    result[:required_actions] = result[:required_actions].merge(and_card.act_on_actions!) if and_card
    result[:allowed_actions] = @after_card.act_on_actions! if @after_card
    
    result
  end
  
  def next_turn!
    @per_turn.each do |k, v|
      @resources[k] = @resources[k].to_i + v
    end
    
    @or_card.next_turn! if @or_card
    @and_or_card.next_turn! if @and_or_card
    @after_card.next_turn! if @after_card
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
  
  def get_actions_from_options(options)
    actions = options.delete(:actions) || {}
    actions.each do |k,v|
      actions.delete(k) unless v
    end
    
    actions
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
  
  def act_on_actions!
    if @actions.has_key?(:family_growth)
      @actions[:family_growth] = {:haste => false, :multiple => false, :rooms => 1}.merge(@actions[:family_growth])
    end
    @actions
  end
  
  def act_on_resources!(options = {})
    resources = @resources.dup

    @fixed.each do |k, v|
      resources[k] += v
    end
    
    @resources.each do |k, v|
      @resources[k] = 0
    end
    
    add_temp_resources(resources, and_or_card) if options[:and_or] == true
    add_temp_resources(resources, after_card) if options[:after] == true
    add_temp_resources(resources, and_card) if and_card
    
    resources.each do |k, v|
      resources.delete(k) if v == 0
    end
    
    resources
  end
  
  def add_temp_resources(resources, card)
    card.act_on_resources!.each do |k,v|
      resources[k] = resources[k].to_i + v
    end
  end
end