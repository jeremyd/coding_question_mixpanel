require 'tempfile'
require 'coding_question_mixpanel'

describe "CodingQuestionMixpanel.ship_log" do

  before do
    CodingQuestionMixpanel.setup_orm(:database => "mysql://testuser:testpass@localhost/testapp", :migrate => true)
    @user_email1 = "mick@example.com"
    @user_email2 = "hello@example.com"
    tempfile = Tempfile.new(['test', '.csv'])
    @filename = tempfile.path
    csv =<<EOF
B,#{@user_email1},2013-03-12T19:50:52.320026
D,#{@user_email1},2013-03-12T19:50:52.320026
D,#{@user_email2},2013-03-12T19:50:52.320026
B,#{@user_email1},2013-03-12T19:50:52.320026
EOF

    File.open(@filename, "w") { |f| f.write(csv) }
  end

  context "with a csv" do
    # populate tmpfile with example csv data.
    it "updates a user record" do
      CodingQuestionMixpanel.log_ship(:logfile => @filename)
      user_to_check = User.first(:email => @user_email1)
      user_to_check.should be
      user_to_check.bounce_count.should == 2
      user_to_check.last_bounce.should be_a(DateTime)
      User.count.should == 2
    end
  end
end
