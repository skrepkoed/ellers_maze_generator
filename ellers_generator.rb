class Row
  attr_accessor :sets,:walls
  def initialize(size)
    @sets=(0...size).to_a
    @walls=Array.new(size-1){|i|i=true}
    @floors=Array.new(size){|i|i=true}
  end

  def join_adjecent
    sets.each do |i|
      if [true,false].sample
        if sets[i]
          walls[i]=false
          sets[i+1]=i
        end
      end 
    end
  end
end

r=Row.new(5)
r.join_adjecent
print r.sets
print r.walls