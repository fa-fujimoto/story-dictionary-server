module Article
  extend ActiveSupport::Concern

  included do
    before_validation :set_last_editor, on: :create

    article_params_length = Settings.model.params_length.article

    has_many :attribute_items, through: :attribute_values

    belongs_to :project
    belongs_to :author, class_name: 'User', foreign_key: 'user_id'
    belongs_to :last_editor, class_name: 'User', foreign_key: 'last_editor_id'

    validates :project, presence: true
    validates :author, presence: true
    validates :last_editor, presence: true

    validates :term_id, presence: true,
      format: { with: /\A[\w]+\z/ },
      length: {
        minimum: article_params_length.term_id.min,
        maximum: article_params_length.term_id.max
      },
      uniqueness: { scope: :project }

    validates :name, presence: true,
      length: {
        minimum: article_params_length.name.min,
        maximum: article_params_length.name.max
      }
    validates :kana,
      format: { with: /\A[\p{hiragana}\w][\p{hiragana}ー、。・　\s\w]*\z/, allow_blank: true },
      length: {
        minimum: article_params_length.kana.min,
        maximum: article_params_length.kana.max
      }
    validates :synopsis,
      length: {
        minimum: article_params_length.synopsis.min,
        maximum: article_params_length.synopsis.max,
        allow_blank: true
      }
    validates :body,
      length: {
        minimum: article_params_length.body.min,
        maximum: article_params_length.body.max,
        allow_blank: true
      }

    validates :is_published, :is_draft,
      inclusion: {in: [true, false]}

    scope :published, -> { where(is_published: true, is_draft: false) }

    def setable_attribute?(attr)
      attr && (attr.project === self.project || attr.project.nil?)
    end

    private
    def set_last_editor
      if last_editor.nil?
        self.last_editor = author
      end
    end

  end
end