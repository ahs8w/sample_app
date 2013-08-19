class Micropost < ActiveRecord::Base
  belongs_to :user
  default_scope -> { order('created_at DESC') }       # default is order by user_id
    # rails version of an anonymous function:  scope '->' criteria desired for scope
    # 'Proc'(procedure) or 'lambda':  scope need not be evaluated immediately; loaded later as-needed
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }


## Implementing a feed: microposts by both user and followed_users ##
## Includes Ruby, Rails, SQL
  def self.from_users_followed_by(user)
    followed_user_ids = "SELECT followed_id FROM relationships 
                         WHERE follower_id = :user_id"            # SQL subselect -> better scaling
    where("user_id IN (#{followed_user_ids}) OR user_id = :user_id",
          user_id: user.id)                        # :symbols work the same as '?', can be used again
    # this implementation allows all the set logic to be pushed into the database -> more efficient
  end
end

    # followed_user_ids = user.followed_user_ids    # puts all followed_user's ids into memory (and an array)
                                                    # we just want to check for inclusion in a set
    # where("user_id IN (?) OR user_id = ?", followed_user_ids, user)
                # this implementation doesn't scale well when number of posts in the feed is large
 
