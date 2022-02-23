class Map
    attr_accessor :array
    attr_accessor :xlen
    attr_accessor :ylen
    def initialize(tab)
        @array = tab
        @xlen = tab[0].length
        @ylen = tab.length
    end
end
