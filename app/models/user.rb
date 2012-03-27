#encoding: UTF-8
class User < ActiveRecord::Base
  #has_and_belongs_to_many :cards, :table_name => :duels_users_cards
  has_many :duel_user_cards
  has_many :cards, :through => :duel_user_cards
  has_many :wins, :class_name => "Duel", :foreign_key => :winner_id

  belongs_to :role

  validates :name,  :presence => true,
    :length => {:minimum => 1, :maximum => 254}  
  #  validates :email, :presence => true,   
  #                    :length => {:minimum => 3, :maximum => 254},  
  #                    :uniqueness => true,  
  #                    :format => {:with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i}
  has_many :topics
  has_many :posts, :through => :topics
  
  def top_duels(count = 20)
    duels.reverse_order.limit(count)
  end
  def duels
    Duel.where("user1_id=? or user2_id=?", id,id)
  end
  def losts
    duels - wins
  end
  
  def to_s
    "<a href=\"/users/#{id}\">#{name}</a>".html_safe
  end
  def avatar(size=nil)
    size = case size
    when :small
      48
    when Integer
      size
    else
    	120
    end
    "<a href=\"/users/#{id}\"><img src=\"http://www.gravatar.com/avatar/#{Digest::MD5.hexdigest(email.strip.downcase)}?size=#{size}\" /></a>".html_safe
  end
  
  
  class <<self  #TODO
    alias old_find find
    def find(*args)
      if args[0].to_i.zero?
        Guest
      else
        old_find(*args)
      end
    end
  end
  Guest = User.new :name => 'guest',
    :nickname => '',
    :password => '',
    :email => '',
    :role_id  => 6,
    :regip => '127.0.0.1',
    :lastloginip => '127.0.0.1',
    :viewnum => 0,
    :onlinetime => 0,
    :credit1 => 0,
    :credit2 => 0,
    :credit3 => 0,
    :credit4 => 0,
    :credit5 => 0,
    :credit6 => 0,
    :credit7 => 0,
    :credit8 => 0
  Guest.id = 0
  def Guest.create
  end
end