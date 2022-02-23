class Camera
    attr_accessor :x
    attr_accessor :y
    attr_accessor :angle
    attr_accessor :fov

    def initialize(x = 0,y = 0, angle = 90, fov = 90) #angle 0 = droite
        @x = x
        @y = y
        @angle = 360-angle #sens trigonométrique
        @fov = fov
    end
end
