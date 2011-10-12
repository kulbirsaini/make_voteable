module MakeVoteable
  module Voteable
    extend ActiveSupport::Concern

    included do
      has_many :votings, :class_name => "MakeVoteable::Voting", :as => :voteable
    end

    module ClassMethods
      def voteable?
        true
      end
    end

    # Return the difference of down and up votes.
    # May be negative if there are more down than up votes.
    def votes
      self.up_votes - self.down_votes
    end

    def votes_up
      Voting.where(:voteable_id => id, :voteable_type => self.class.name, :up_vote => true).count
    end

    def votes_down
      Voting.where(:voteable_id => id, :voteable_type => self.class.name, :up_vote => false).count
    end

    def percent_up
      (votes_up.to_f * 100 / (self.votings.size + 0.0001)).round
    end

    def percent_down
      (votes_down.to_f * 100 / (self.votings.size + 0.0001)).round
    end

    def voters_who_voted
      self.votings.map(&:voter).uniq
    end

    def voted_by?(voter)
      Voting.where(
        :voteable_id => self.id,
        :voteable_type => self.class.name,
        :voter_type => voter.class.name,
        :voter_id => voter.id
      ).exists?
    end

  end
end
