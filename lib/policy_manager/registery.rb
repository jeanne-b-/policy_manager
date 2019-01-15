module PolicyManager
  class Registery
    attr_accessor :registery

    def initialize
      @registery = Config.registery
    end

    def data_dump_for(owner)
      registery = registery_for(owner).map do |resource|
        if resource.is_a? Symbol
          [resource, serialize_collection(owner.send(resource))]
        elsif resource.is_a? Hash
          resource_name = resource.keys[0]
          options = resource[resource_name]
          if options.respond_to?('[]', :finder) and options[:finder]
            [resource_name, serialize_collection(options[:finder].call(owner), options)]
          else
            [resource_name, serialize_collection(owner.send(resource_name), options)]
          end
        end
      end
      registery.to_h
    end

    def serialize_collection(collection, options = nil)
      collection = collection.respond_to?(:map) ? collection : [collection]
      collection = collection.map {|item| serialize_item(item, options)}
      if options.respond_to?('[]', :description) and options[:description]
        {description: options[:description], data: collection}
      else
        {data: collection}
      end
    end

    def serialize_item(item, options)
      if ("#{item.class.to_s}PortabilitySerializer".constantize rescue nil)
        "#{item.class.to_s}PortabilitySerializer".constantize.new(item).as_json
      else
        item.attributes rescue nil
      end
    end

    def registery_for(owner)
      @registery.try('[]', owner.class.name.underscore.to_sym)
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
