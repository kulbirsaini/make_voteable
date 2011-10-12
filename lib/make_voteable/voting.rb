module MakeVoteable
  class Voting < ActiveRecord::Base
    attr_accessible :voteable, :voter, :voter_id, :voter_type, :up_vote

    belongs_to :voteable, :polymorphic => true
    belongs_to :voter, :polymorphic => true

    scope :for_voter, lambda { |*args| where(["voter_id = ? AND voter_type = ?", args.first.id, args.first.class.name]) }
    scope :for_voteable, lambda { |*args| where(["voteable_id = ? AND voteable_type = ?", args.first.id, args.first.class.name]) }
    scope :recent, lambda { |*args| where(["created_at > ?", (args.first || 2.weeks.ago)]) }
    scope :descending, order("created_at DESC")
  end
end
