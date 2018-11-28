require "aasm"

module PolicyManager
  class Term < ApplicationRecord
    include AASM
    include ClassyEnum::ActiveRecord
    classy_enum_attr :kind, class_name: TermKind

    has_many :users_terms
    has_many :terms_translations, inverse_of: :term
    has_one :terms_translation, -> () { where(locale: [I18n.locale, :en]) }
    accepts_nested_attributes_for :terms_translations, reject_if: :all_blank, allow_destroy: true

    validates_presence_of :state

    aasm column: :state do
      state :draft, initial: true
      state :published

      event :publish do
         transitions :from => :draft, :to => :published
      end
    end

    def signed_by?(user)
      self.users_terms.where(owner: user).any?
    end
  end
end
