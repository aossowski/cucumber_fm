require 'spec_helper'

describe CucumberFM::FeatureElement::Info do
  before(:all) do
    @comments_raw = %q{# some comment
# wireframe:: http://cs3b.com}
    @tags_raw = "@tag @mc"
    @title = "Tag filter"
    raw = <<EOF
#{@comments_raw}
#{@tags_raw}
Feature: #{@title}
  In order to fetch only scenarios that i want
  as project manager, developer
  I want to be able to create filter scope
EOF
    feature = CucumberFM::Feature.new('fake_path')
    @info = CucumberFM::FeatureElement::Info.new(feature, raw)
  end
  it "should parse tags" do
    @info.tags.should == %w(@tag @mc)
  end
  it "should parse comments lines" do
    CucumberFM::CommentModule::Comment.should_receive(:new).with(subject, @comments_raw)
    subject.should have(2).comments
  end
  it "should parse title" do
    subject.title.should =~ @title
  end
  it "should parse narrative"
end