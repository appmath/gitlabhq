class Board < ActiveRecord::Base
  prepend EE::Board

  belongs_to :project

  has_many :lists, -> { order(:list_type, :position) }, dependent: :delete_all # rubocop:disable Cop/ActiveRecordDependent

  validates :name, presence: true
  validates :project, presence: true, unless: -> { respond_to?(:group_id) }

  def backlog_list
    lists.merge(List.backlog).take
  end

  def closed_list
    lists.merge(List.closed).take
  end
end
