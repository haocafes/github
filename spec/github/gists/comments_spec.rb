# encoding: utf-8

require 'spec_helper'

describe Github::Gists::Comments do
  let(:github) { Github.new }
  let(:gist_id)    { '1' }
  let(:comment_id) { 1 }

  after { reset_authentication_for(github) }

  describe "#get" do
    it { github.gists.should respond_to :find }

    context 'resource found' do
      before do
        stub_get("/gists/#{gist_id}/comments/#{comment_id}").
          to_return(:body => fixture('gists/comment.json'),
          :status => 200,
          :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should fail to get resource without comment id" do
        expect { github.gists.comments.get nil, nil }.to raise_error(ArgumentError)
      end

      it "should get the resource" do
        github.gists.comments.get gist_id, comment_id
        a_get("/gists/#{gist_id}/comments/#{comment_id}").should have_been_made
      end

      it "should get comment information" do
        comment = github.gists.comments.get gist_id, comment_id
        comment.id.should eq comment_id
        comment.user.login.should == 'octocat'
      end

      it "should return mash" do
        comment = github.gists.comments.get gist_id, comment_id
        comment.should be_a Hashie::Mash
      end
    end

    context 'resource not found' do
      before do
        stub_get("/gists/#{gist_id}/comments/#{comment_id}").
          to_return(:body => fixture('gists/comment.json'),
            :status => 404,
            :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should fail to retrive resource" do
        expect {
          github.gists.comments.get gist_id, comment_id
        }.to raise_error(Github::Error::NotFound)
      end
    end
  end # get

  describe "#create" do
    let(:inputs) {
      { "body" =>"Just commenting for the sake of commenting",
        "unrelated" => true }
    }

    context "resouce created" do
      before do
        stub_post("/gists/#{gist_id}/comments").
          with(inputs.except('unrelated')).
          to_return(:body => fixture('gists/comment.json'),
                :status => 201,
                :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should fail to create resource if 'content' input is missing" do
        expect {
          github.gists.comments.create gist_id, inputs.except('body')
        }.to raise_error(Github::Error::RequiredParams)
      end

      it "should create resource successfully" do
        github.gists.comments.create gist_id, inputs
        a_post("/gists/#{gist_id}/comments").with(inputs).should have_been_made
      end

      it "should return the resource" do
        comment = github.gists.comments.create gist_id, inputs
        comment.should be_a Hashie::Mash
      end

      it "should get the comment information" do
        comment = github.gists.comments.create gist_id, inputs
        comment.user.login.should == 'octocat'
      end
    end

    context "failed to create resource" do
      before do
        stub_post("/gists/#{gist_id}/comments").with(inputs).
          to_return(:body => fixture('gists/comment.json'),
            :status => 404,
            :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should faile to retrieve resource" do
        expect {
          github.gists.comments.create gist_id, inputs
        }.to raise_error(Github::Error::NotFound)
      end
    end
  end # create

  describe "#edit" do
    let(:inputs) {
      { "body" =>"Just commenting for the sake of commenting", "unrelated" => true }
    }

    context "resouce edited" do
      before do
        stub_patch("/gists/#{gist_id}/comments/#{comment_id}").
          with(inputs.except('unrelated')).
          to_return(:body => fixture('gists/comment.json'),
                :status => 201,
                :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should fail to create resource if 'content' input is missing" do
        expect {
          github.gists.comments.edit gist_id, comment_id, inputs.except('body')
        }.to raise_error(Github::Error::RequiredParams)
      end

      it "should create resource successfully" do
        github.gists.comments.edit gist_id, comment_id, inputs
        a_patch("/gists/#{gist_id}/comments/#{comment_id}").with(inputs).should have_been_made
      end

      it "should return the resource" do
        comment = github.gists.comments.edit gist_id, comment_id, inputs
        comment.should be_a Hashie::Mash
      end

      it "should get the comment information" do
        comment = github.gists.comments.edit gist_id, comment_id, inputs
        comment.user.login.should == 'octocat'
      end
    end

    context "failed to create resource" do
      before do
        stub_patch("/gists/#{gist_id}/comments/#{comment_id}").with(inputs).
          to_return(:body => fixture('gists/comment.json'),
            :status => 404,
            :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should faile to retrieve resource" do
        expect {
          github.gists.comments.edit gist_id, comment_id, inputs
        }.to raise_error(Github::Error::NotFound)
      end
    end
  end # edit

  describe "#delete" do
    context "resouce deleted" do
      before do
        stub_delete("/gists/#{gist_id}/comments/#{comment_id}").
          to_return(:body => '',
                :status => 204,
                :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should fail to create resource if 'content' input is missing" do
        expect { github.gists.comments.delete gist_id, nil }.to raise_error(ArgumentError)
      end

      it "should create resource successfully" do
        github.gists.comments.delete gist_id, comment_id
        a_delete("/gists/#{gist_id}/comments/#{comment_id}").should have_been_made
      end
    end

    context "failed to create resource" do
      before do
        stub_delete("/gists/#{gist_id}/comments/#{comment_id}").
          to_return(:body => fixture('gists/comment.json'),
            :status => 404,
            :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should faile to retrieve resource" do
        expect {
          github.gists.comments.delete gist_id, comment_id
        }.to raise_error(Github::Error::NotFound)
      end
    end
  end # delete

end # Github::Gists::Comments
