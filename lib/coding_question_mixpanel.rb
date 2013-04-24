require 'data_mapper'
require 'dm-transactions'
require 'coding_question_mixpanel/db/user'

class CodingQuestionMixpanel
  def self.setup_orm(options)
    DataMapper.setup(:default, options[:database])
    DataMapper::Logger.new($stdout, :info)
    # destructive migrate if specified
    DataMapper.auto_migrate! if options[:migrate]
    DataMapper.finalize
  end

  def self.log_ship(options)
    CSV.foreach(options[:logfile]) do |row|
      # Must use transactions since multiple servers will potentially be attempting to update the same record.
      User.transaction do
        row[0] # status
        row[1] # email
        row[2] # datetime
        update_this_user = User.first(:email => row[1])
        update_this_user = User.create(:email => row[1]) unless update_this_user
        update_this_user.bounce_count += 1 if row[0] == "B"
        if update_this_user.last_bounce
          update_this_user.last_bounce = row[2] unless DateTime.parse(row[2]) < update_this_user.last_bounce 
        else
          update_this_user.last_bounce = row[2]
        end
        update_this_user.save
      end
    end
  end
end
