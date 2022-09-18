require 'rmagick'
class Row
  attr_accessor :sets,:walls,:map, :floors
  def initialize(size)
    @map=Hash.new{|h,i| h[i]=Array.new}
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
    self
  end

  def make_passage
    @map.each do |k,v|
      floors[v.sample]=false
      (v.size-1).times do |i|
        floors[i]=false
      end
    end
    self
  end

  def create_next_row
    next_row=Row.new(self.sets.size)
    floors.each_with_index do |floor,i|
      unless floor
        next_row.sets[i]=self.sets[i]
      else
        next_row.sets[i]=self.sets.max+1
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

class Maze
  attr_accessor :maze
  def initialize(x,y)
    @maze=[Row.new(x).join_adjecent.make_passage]
    y.times do |rows|
      @maze<<@maze.last.create_next_row.join_adjecent.make_passage
    end
    @maze.last.walls.map!{|wall| wall=false }
  end
end
maze=Maze.new(6,6)
x=Array.new(9){|i| i*80}
y=Array.new(9){|i| i*60}
imgl = Magick::ImageList.new
imgl.new_image(480, 420)
gc = Magick::Draw.new
gc.stroke_width(3)
gc.stroke('black')



maze.maze.each_with_index do |rows_cells, row|
  rows_cells.walls.each_with_index do |wall,index|
    if wall
      gc.line(x[index+1],y[row],x[index+1],y[row+1])
    end
  end
  rows_cells.floors.each_with_index do |floor,index|
    if floor
      gc.line(x[index],y[row+1],x[index+1],y[row+1])
    end
  end
end

gc.draw(imgl)
imgl.border!(1,1, "LightCyan2")

imgl.write("line2.gif")




=begin
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
=end
p maze


