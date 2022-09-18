class Row
  attr_accessor :sets,:walls,:map, :floors
  def initialize(size)
    @map=Hash.new{|h,i| h[i]=Array.new}
    #@map.default=Array.new
    @sets=(0...size).to_a
    @walls=Array.new(size-1){|i|i=true}
    @floors=Array.new(size){|i|i=true}
  end

  def join_adjecent
    sets.each_with_index do |k,i|
      if [true,false].sample
        if sets[i+1]
          walls[i]=false
          sets[i+1]=k
        end
      end 
    end
    floor_map
  end

  def make_passage
    @map.each do |k,v|
      floors[v.sample]=false
      (v.size-1).times do |i|
        floors[i]=false
      end
    end
  end

  def create_next_row
    next_row=Row.new(self.sets.size)
    floors.each_with_index do |floor,i|
      unless floor
        next_row.sets[i]=self.sets[i]
      else
        next_row.sets[i]=next_row.sets.max+1
      end
    end
    next_row
  end
  private 
  def floor_map
    @sets.each_with_index do |k,index|
      @map[k]<<index
    end
  end
end

r=Row.new(5)
r.join_adjecent
r.make_passage
r1=r.create_next_row
print r.sets 
puts "\n"
print r.walls 
puts "\n"
print r.floors 
puts "\n"
print r1.sets
puts "\n" 
print r1.walls 
puts "\n"
print r1.floors 
