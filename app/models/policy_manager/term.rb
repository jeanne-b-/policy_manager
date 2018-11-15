module PolicyManager
  class Term < ApplicationRecord
    validates_presence_of :title
    validates_presence_of :description
    validates_presence_of :state

    validates_inclusion_of :locale, in: -> (_) { I18n.available_locales.map(&:to_s) }, allow_nil: false
  end
end
