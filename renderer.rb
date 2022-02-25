require 'matrix'

class Renderer
    attr_accessor :viewComponent

    def initialize(hauteur = 1)
        @viewComponent = []
        @hauteur = hauteur
    end

    def render3D(monde)
        @viewComponent.each { |element|  element.remove }
        @viewComponent = []
        cos45 = Math.cos(40)
        # calcul hauteur FG (hauteur visible à la distance AH entre camera et arrête) à partir du cosinus (sohcahtoa)
        # fraction: hauteur écran = hmur/hvisible


        # calcul angle et distance de l'arrete avec deux équation de droite (cam-mur et droite de l'angle), on cherche x et y ou ax1+by1+c1 = ax2+by2+c2

        camx = monde.camera.x
        camy = monde.camera.y

        camToPointAngleV = Vector[Math.cos(to_rad(monde.camera.angle)),Math.sin(to_rad(monde.camera.angle))]
        monde.map.array.each_index do |y|
            monde.map.array[y].each_index do |x|
                arrete = []

                for n in 0..3
                    i = n/2
                    j = n%2

                    current = monde.map.array[y][x]
                    next if current == 0 # je ne prends que les murs

                    #le mur est-il devant la camera (à 180°)
                    yrelative = (y+j-camy).to_f
                    xrelative = (x+i-camx).to_f
                    distance = Math.sqrt(xrelative*xrelative + yrelative*yrelative)
                    # puts "[#{x}][#{y}]: x: #{xrelative} y:#{yrelative}"

                    #angle entre 2 vecteur
                    camToArreteV = Vector[xrelative,yrelative]
                    # puts "#{y/camToArreteV.norm}"
                    cos = xrelative/camToArreteV.norm
                    absoluteAngleVector = 180-Math.acos(cos)*180/Math::PI

                    if yrelative < 0
                        absoluteAngleVector = 0-absoluteAngleVector
                    end
                    # puts "[#{x}][#{y}]: #{absoluteAngleVector}"
                    angleCam = 360-monde.camera.angle
                    diff = (angleCam - absoluteAngleVector)%360
                    if diff >= 90 && diff <= 270
                        # cote = 'devant'
                        if diff < 180
                            cote = 'left'
                        else
                            cote = 'right'
                        end
                    else
                        cote = 'derrie'

                    end
                    # puts "[#{x}][#{y}]: #{cote}\tdiff #{diff.to_i}\tvecteur: #{absoluteAngleVector.to_i}\tcam: #{angleCam} yrelative: #{yrelative}"

                    winxsize = Window.width
                    winysize = Window.height
                    fov = monde.camera.fov
                    xwindowedpos = ((diff-90-45)/180)*winxsize*180/fov
                    # puts "[#{x}][#{y}]: #{1/(Math.cos(45)*distance)}" #180-90-45
                    hauteurvisible = cos45*distance
                    ywindowzedsize = winysize*@hauteur/hauteurvisible #demi hauteur d'écran
                    # puts "[#{x}][#{y}]: #{ywindowzedsize}"
                    @viewComponent << Line.new(
                        x1:xwindowedpos ,y1: (winysize-ywindowzedsize)/2,
                        x2:xwindowedpos ,y2: winysize-(winysize-ywindowzedsize)/2,
                        color: 'white',
                        z: 1
                    )

                    arrete.append(@viewComponent[-1])
                end

                if cote == 'left' or cote == 'right'
                    # puts "[#{x}][#{y}]"
                    # p arrete[0]
                    # p arrete[1]

                    #0-2
                    @viewComponent << Line.new(
                        x1:arrete[0].x1 ,y1: arrete[0].y1,
                        x2:arrete[2].x1 ,y2: arrete[2].y1,
                        color: 'white',
                        z: 1
                    )
                    @viewComponent << Line.new(
                        x1:arrete[0].x2 ,y1: arrete[0].y2,
                        x2:arrete[2].x2 ,y2: arrete[2].y2,
                        color: 'white',
                        z: 1
                    )

                    #2-3
                    @viewComponent << Line.new(
                        x1:arrete[2].x1 ,y1: arrete[2].y1,
                        x2:arrete[3].x1 ,y2: arrete[3].y1,
                        color: 'white',
                        z: 1
                    )
                    @viewComponent << Line.new(
                        x1:arrete[2].x2 ,y1: arrete[2].y2,
                        x2:arrete[3].x2 ,y2: arrete[3].y2,
                        color: 'white',
                        z: 1
                    )

                    #3-1
                    @viewComponent << Line.new(
                        x1:arrete[3].x1 ,y1: arrete[3].y1,
                        x2:arrete[1].x1 ,y2: arrete[1].y1,
                        color: 'white',
                        z: 1
                    )
                    @viewComponent << Line.new(
                        x1:arrete[3].x2 ,y1: arrete[3].y2,
                        x2:arrete[1].x2 ,y2: arrete[1].y2,
                        color: 'white',
                        z: 1
                    )

                    #1-0
                    @viewComponent << Line.new(
                        x1:arrete[1].x1 ,y1: arrete[1].y1,
                        x2:arrete[0].x1 ,y2: arrete[0].y1,
                        color: 'white',
                        z: 1
                    )
                    @viewComponent << Line.new(
                        x1:arrete[1].x2 ,y1: arrete[1].y2,
                        x2:arrete[0].x2 ,y2: arrete[0].y2,
                        color: 'white',
                        z: 1
                    )
                end
            end
        end

        # puts '==================================='
    end
end
