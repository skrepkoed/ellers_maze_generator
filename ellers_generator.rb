require 'rmagick'
class Row
  attr_accessor :sets,:walls,:map, :floors, :max_id
  def initialize(size)
    @max_id=size-1
    @map=Hash.new{|h,i| h[i]=Array.new}
    @sets=(0...size).to_a
    @walls=Array.new(size-1){|i|i=true}
    @floors=Array.new(size){|i|i=true}
  end

  def join_adjecent
    sets.each_with_index do |k,i|
      if [true,false,false].sample
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
        @max_id+=1
        next_row.sets[i]=@max_id
      end
    end
    next_row.max_id=next_row.sets.max 
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
maze=Maze.new(15,15)
x=Array.new(42){|i| i*30}
y=Array.new(42){|i| i*26.25}
pic = Magick::Image.read("grass_for_maze.png").first
pic1 = Magick::Image.read("grass_for_maze1.png").first
background=Magick::Image.read("road.png").first
imgl = Magick::ImageList.new
imgl.new_image(480, 420)
gc = Magick::Draw.new
gc.pattern('road',0,0,background.columns, background.rows){
  gc.composite(0, 0, 0, 0, background)
}
gc.fill('road')
gc.rectangle(0,0,480,420)
gc.pattern('grass',0,0,pic.columns, pic.rows){
    gc.composite(0, 0, 0, 0, pic)
}
gc.pattern('grass1',0,0,pic1.columns, pic1.rows){
  gc.composite(0, 0, 0, 0, pic1)
}


maze.maze.each_with_index do |rows_cells, row|
  rows_cells.walls.each_with_index do |wall,index|
    if wall
      gc.fill(['grass','grass1'].sample)
      gc.rectangle(x[index+1],y[row],x[index+1]+2,y[row+1])
    end
  end
  rows_cells.floors.each_with_index do |floor,index|
    if floor
      gc.fill(['grass','grass1'].sample)
      gc.rectangle(x[index],y[row+1],x[index+1],y[row+1]+2)
    end
  end
end

gc.draw(imgl)
imgl.border!(1,1, "LightCyan2")

imgl.write("line7.gif")
p "Maze log: #{p maze}"


