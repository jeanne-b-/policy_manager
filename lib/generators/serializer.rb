require 'rails/generators'

module PolicyManager
  module Generators
    class PortabilitySerializerGenerator < ::Rails::Generators::NamedBase
            source_root File.expand_path('../../templates', __FILE__)

      argument :attributes, type: :array, default: [], banner: 'field:type field:type'

      class_option :parent, type: :string, desc: 'The parent class for the generated serializer'

      def create_serializer_file
        template 'serializer.rb', File.join('app/serializers', class_path, "#{file_name}_portability_serializer.rb")
      end

      private

      def attributes_names
         model.column_names.map(&:to_sym) - [:id]
      end

      def has_manys
        model.reflect_on_all_associations.select {|ass| ass.is_a? ActiveRecord::Reflection::HasManyReflection }.map &:name
      end

      def has_ones
        model.reflect_on_all_associations.select {|ass| ass.is_a? ActiveRecord::Reflection::BelongsToReflection }.map &:name
      end

      def model
        file_name.classify.constantize
      end

      def association_names
        attributes.select { |attr| attr.reference? }.map { |a| a.name.to_sym }
      end

      def parent_class_name
        if options[:parent]
          options[:parent]
        elsif (ns = Rails::Generators.namespace) && ns.const_defined?(:ApplicationSerializer) ||
               (Object.const_get(:ApplicationSerializer) rescue nil)
          'ApplicationSerializer'
        else
          'ActiveModel::Serializer'
        end
      end
    end
  end
end
