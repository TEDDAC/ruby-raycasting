require 'ruby2d'
require_relative 'map.rb'
require_relative 'monde.rb'
require_relative 'camera.rb'
require_relative 'minimap.rb'
require_relative 'renderer.rb'

def to_rad(angle)
    angle/180.0*Math::PI
end

sizewx = 1280
sizewy = 720

set title: 'Fractale'
set background: 'black'
set width: sizewx, height: sizewy

map = []
map[0] = [1,1,1,1,1,1,1]
map[1] = [1,0,0,0,0,0,1]
map[2] = [1,0,1,1,0,0,1]
map[3] = [1,0,1,1,0,0,1]
map[4] = [1,0,0,0,0,0,1]
map[5] = [1,0,0,0,0,1,1]
map[6] = [1,1,1,1,1,1,1]

map = Map.new(map)
#p map

camera = Camera.new(3,3,270,80)

minimap = Minimap.new(0,0,200,2)
monde = Monde.new(camera,map)

minimap.draw(monde)


on :key_held do |event|
    #p event
    case event.key
    when 'w'
        camera.x += Math.cos(to_rad(camera.angle))*0.03
        camera.y += Math.sin(to_rad(camera.angle))*0.03
    when 's'
        camera.x -= Math.cos(to_rad(camera.angle))*0.03
        camera.y -= Math.sin(to_rad(camera.angle))*0.03
    when 'd'
        camera.x -= Math.cos(to_rad(camera.angle-90))*0.03
        camera.y -= Math.sin(to_rad(camera.angle-90))*0.03
    when 'a'
        camera.x += Math.cos(to_rad(camera.angle-90))*0.03
        camera.y += Math.sin(to_rad(camera.angle-90))*0.03
    end
    minimap.updateCam(camera)
end

on :key_held do |event|
    #p event
    case event.key
    when 'right'
        camera.angle += 2
    when 'left'
        camera.angle -= 2
    end
    minimap.updateCam(camera)
end

show
