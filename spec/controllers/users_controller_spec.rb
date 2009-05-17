require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe UsersController do

  it "should get a collection of users when asked for index" do
    User.should_receive(:find).with(:all)
    get :index
  end

  it "should assign the users to the view" do
    User.stub!(:find).and_return(['user'])
    get :index
    assigns(:users).should == ['user']
  end

end
