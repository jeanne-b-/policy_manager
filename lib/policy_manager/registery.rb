module PolicyManager
  class Registery
    attr_accessor :registery

    def initialize
      @registery = YAML.load(File.read('../ft_core/config/rgpd_registery.yml'))['registery']
    end

    def data_dump_for(owner)
      if owner.is_a? User 
        @registery.map {|k, v| v}.flatten.each do |item|
          if item.is_a?(String)
            fetch_collection(owner, item)
          else
          end
        end
      end
    end


    def fetch_collection(owner, item)
      
    end

    def registered?(table_name)
      @registery.map {|k, v| v}.flatten.find do |item|
        item.is_a?(String) ? item == table_name : item.keys == [table_name]
      end
    end
  end
end
