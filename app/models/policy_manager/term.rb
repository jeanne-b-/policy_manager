require "aasm"

module PolicyManager
  class Term < ApplicationRecord
    include AASM
    include ClassyEnum::ActiveRecord

    classy_enum_attr :kind, class_name: TermKind

    has_many :users_terms
    has_many :terms_translations, inverse_of: :term

    has_one :terms_translation, -> () { order(Arel.sql("locale = '#{I18n.locale}' DESC, locale = 'en' DESC")) }

    accepts_nested_attributes_for :terms_translations, reject_if: :all_blank, allow_destroy: true

    scope :mandatory_for_user,  -> (user) { where(state: :published, kind: :mandatory, target: [user.class.name, nil]) }

    validates_presence_of :state
    validate :translations_count_valid?

    before_validation :nullify_values

    aasm column: :state do
      state :draft, initial: true
      state :published
      state :archived

      event :publish do
         transitions :from => :draft, :to => :published
         transitions :from => :archived, :to => :published
      end

      event :archive do
         transitions :from => :draft, :to => :archived
         transitions :from => :published, :to => :archived
      end
    end

    def signed_by?(user)
      self.users_terms.where(owner: user).any?
    end

    private

    def nullify_values
      self.target = nil if self.target.blank?
    end

    def translations_count_valid?
      self.errors.add(:terms_translations, :translations_missing) and return false unless terms_translations.reject(&:marked_for_destruction?).count > 0
    end
  end
end
