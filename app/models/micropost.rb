class Micropost < ActiveRecord::Base
  belongs_to :user
  default_scope -> { order('created_at DESC') }       # default is order by user_id
    # rails version of an anonymous function:  scope '->' criteria desired for scope
    # 'Proc'(procedure) or 'lambda':  scope need not be evaluated immediately; loaded later as-needed
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
end
