class Minimap
    attr_accessor :x
    attr_accessor :y
    attr_accessor :size
    attr_accessor :borderwidth
    attr_accessor :triangle

    def initialize(x = 0, y = 0, size = 200, borderwidth = 2)
        @x = x
        @y = y
        @size = size
        @borderwidth = borderwidth
        @padding = 20
        @sizecamera = 1
    end

    def draw(monde)
        Line.new(
            x1:0 , y1: @size,
            x2: @size, y2: @size,
            width: @borderwidth,
            color: 'white',
            z: 5
        )
        Line.new(
            x1:@size , y1: 0,
            x2: @size, y2: @size,
            width: @borderwidth,
            color: 'white',
            z: 5
        )
        Square.new(
          x: 0, y: 0,
          size: @size-@borderwidth,
          color: 'black',
          z: 5
        )

        @unite = (@size-2*@padding)/monde.map.xlen

        #puts "minimap drawn. size: #{@size}, unite is #{@unite} per int"

        #dessin de la map
        monde.map.array.each_index do |y|
            monde.map.array[y].each_index do |x|
                #puts "#{x}:#{y}"
                current = monde.map.array[y][x]
                if current == 1
                    Line.new( #ligne du haut
                        x1: @padding+x*@unite , y1: @padding+y*@unite,
                        x2: @padding+x*@unite+@unite, y2: @padding+y*@unite,
                        width: @borderwidth,
                        color: 'white',
                        z: 5
                    )
                    Line.new( #ligne du bas
                        x1: @padding+x*@unite , y1: @padding+y*@unite+@unite,
                        x2: @padding+x*@unite+@unite, y2: @padding+y*@unite+@unite,
                        width: @borderwidth,
                        color: 'white',
                        z: 5
                    )
                    Line.new( #ligne de gauche
                        x1: @padding+x*@unite , y1: @padding+y*@unite,
                        x2: @padding+x*@unite, y2: @padding+y*@unite+@unite,
                        width: @borderwidth,
                        color: 'white',
                        z: 5
                    )
                    Line.new( #ligne de droite
                        x1: @padding+x*@unite+@unite , y1: @padding+y*@unite,
                        x2: @padding+x*@unite+@unite, y2: @padding+y*@unite+@unite,
                        width: @borderwidth,
                        color: 'white',
                        z: 5
                    )
                end
            end
        end

        @triangle = Triangle.new(z: 5,color: 'blue')
        self.updateCam(monde.camera)
    end

    def updateCam(camera)
        #dessin de la camera
        xcam = camera.x*@unite+@padding
        ycam = camera.y*@unite+@padding
        angle = camera.angle
        fov = camera.fov
        sizecamunited = @sizecamera*@unite
        # puts "x2: #{xcam+(Math.cos(to_rad(angle-45+fov)))*sizecamunited}"
        # puts "y2: #{ycam+(Math.sin(to_rad(angle-45+fov)))*sizecamunited}"
        # puts "x3: #{xcam+(Math.cos(to_rad(angle-45)))*sizecamunited}"
        # puts "y3: #{ycam+(Math.sin(to_rad(angle-45)))*sizecamunited}"
        @triangle.x1 = xcam
        @triangle.y1 = ycam
        @triangle.x2 = xcam+(Math.cos(to_rad(angle-fov/2)))*sizecamunited
        @triangle.y2 = ycam+(Math.sin(to_rad(angle-fov/2)))*sizecamunited
        @triangle.x3 = xcam+(Math.cos(to_rad(angle+fov/2)))*sizecamunited
        @triangle.y3 = ycam+(Math.sin(to_rad(angle+fov/2)))*sizecamunited
    end
end
