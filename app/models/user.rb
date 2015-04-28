class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  belongs_to :team

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :status, :first_name, :last_name, :web_site, :team_id, :current_user

  scope :without_user, lambda {|user| where("id <> :id", :id => user.id) }

  STATUSES = {:in => 0, :out => 1}.freeze

  validates :status, :inclusion => {:in => STATUSES.keys}
  validates :email, presence: true

  def full_name
    [first_name, last_name].join(" ")
  end

  def status=(val)
    write_attribute(:status, STATUSES[val.intern])
  end

  def status
    STATUSES.key(read_attribute(:status))
  end

  def available_for_team?
    team_id == nil
  end

  def self.team_members(current_user)
    User.find_by_sql [
      "SELECT id, email, status, first_name, team_id, last_name 
      FROM users 
      where id <> ? 
      AND team_id == ?",
      current_user.id, current_user.team_id]
  end

  def self.other_members(current_user)
    User.find_by_sql [
      "SELECT id, email, status, first_name, team_id, last_name
      FROM users 
      where id <> ? 
      AND team_id <> ? 
      or team_id IS NULL", 
      current_user.id, current_user.team_id]
  end
end
