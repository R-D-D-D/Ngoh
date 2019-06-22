class Course < ApplicationRecord
  belongs_to :tutor
  has_many :lessons, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  has_many :students, through: :subscriptions, source: :student

  has_one_attached :image
  validate :image_file_type

  scope :newest,        -> { order(created_at: :desc) }
  scope :oldest,        -> { order(created_at:  :asc) }
  scope :lowest_price,  -> { order(price:       :asc) }
  scope :highest_price, -> { order(price:      :desc) }

  validates :title,
    presence: true,
    length: { maximum: 50 }

  validates :content,
    presence: true

  validates :price,
    presence: true,
    numericality: { greater_than_or_equal_to: 0 }

  validates :tutor,
    presence: true

  # Queries the Course, Tutor, and Lessons tables
  def Course.search(query)
    query_terms = query.split
    # Create the SQL fragment for individual query terms
    individual_query = ['(LOWER(title) LIKE ?
                        OR LOWER(content) LIKE ? 
                        OR LOWER(tutors.name) LIKE ? 
                        OR LOWER(lessons.name) LIKE ? 
                        OR LOWER(lessons.description) LIKE ?)']
    # Form complete SQL fragment based on number of query terms
    complete_query = [(individual_query * query_terms.length).join(' AND ')]
    # Construct complete array of query terms to feed to SQL fragment
    complete_query_terms = []
    query_terms.each { |query_term| 5.times { complete_query_terms << query_term.downcase } }
    # Add % % to each query term so that it is searched for as a substring
    complete_query_terms.map! { |query_term| "%#{query_term}%" }
    # Execute the complete SQL query
    joins(:tutor, :lessons).where(complete_query + complete_query_terms).distinct
  end

  # Changes the scope (order of courses) based on sort param
  def Course.sort(sort_by)
    case sort_by
    when 'newest'
      newest
    when 'oldest'
      oldest
    when 'lowest_price'
      lowest_price
    when 'highest_price'
      highest_price
    else
      newest
    end
  end

  private

  # Validates that the image is of the correct file type
  def image_file_type
    if image.attached? && !image.content_type.in?(%w[image/png image/jpeg image/gif])
      image.purge # delete the uploaded image
      errors.add(:image, 'must be a PNG, JPEG, or GIF file.')
    end
  end
end
