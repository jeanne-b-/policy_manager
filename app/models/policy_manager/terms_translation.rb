module PolicyManager
  class TermsTranslation < ApplicationRecord
    belongs_to :term

    validates_presence_of :title
    validates_presence_of :content

    validates_inclusion_of :locale, in: -> (_) { I18n.available_locales.map(&:to_s) }, allow_nil: false

    before_validation :strip_content
    after_commit :htmlize_content

    def strip_content
      self.content = self.content.strip if self.content
    end

    def self.renderer
      @renderer ||= Redcarpet::Markdown.new(Redcarpet::Render::HTML,
                                            autolink: true,
                                            tables: true,
                                            hard_wrap: true,
                                            with_toc_data: true,
                                            filter_html: true)
    end

    def htmlize_content
      self.update_columns(content_html: self.class.renderer.render(self.content))
    end

    def signed_by?(user)
      self.users_terms.where(owner: user).any?
    end
  end
end
