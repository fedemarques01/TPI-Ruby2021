module Polycon
    module Utils
        def self.check_polycon_exists
            if not Dir.exist?(Dir.home << "/.polycon")
                Dir.mkdir(Dir.home << "/.polycon")
            end
        end

        def self.path
            Dir.home << "/.polycon"
        end
    end
end