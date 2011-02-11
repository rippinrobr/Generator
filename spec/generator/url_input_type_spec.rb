require 'spec_helper'
require_relative '../../lib/generator/sources/url/url_code_gen'
require_relative '../../lib/generator/utils/url_manager'

module Generator
  describe Engine do
    let(:options) { { :url => 'http://localhost:8098/riak/era_percentile/1979_AL', :language => 'ruby', :model_class_name => 'seasonal_era_percentile', :model_file_name => '1979_al.rb', :model_output_dir => '/tmp', :service_file_name => '1979_al_service.rb', :service_output_dir => '/tmp', :model_output => :src } }
    let(:output) { double('output').as_null_object }
    let(:url_mgr) { double('url_mgr').as_null_object }
    let(:code_gen) { Generator::Engine.new options, url_mgr, output }

    describe "#selecting the appropriate parser" do
      it "should select the JSON parser when the content_type is JSON" do
        url_mgr.stub(:content_type).and_return("application/json")
        code_gen.parser_name.should == "JsonParser"
      end

      it "should return a nice message when the content_type does not have a parser" do
        
        url_mgr.stub(:content_type).and_return("zzz")
        output.should_recieve(:puts).with("Content Type 'zzz' does not have a corresponding parser")
        
        code_gen.parser_name.should == nil
      end
    end

    describe "#create model class file" do
      before(:all) do 
        @json = "\"{ \"Season\": \"1979\",  \"Position\": \"P\",  \"League\": \"AL\",  \"Rankings\": [{ \"Rank\": \"5\",  \"Value\": \"9\"},{ \"Rank\": \"15\",  \"Value\": \"6.38931297709924\"},{ \"Rank\": \"55\",  \"Value\": \"4.21723518850987\"},{ \"Rank\": \"85\",  \"Value\": \"3.12631578947368\"},{ \"Rank\": \"95\",  \"Value\": \"1.57342657342657\"}]}\""
      end

      it "should be able to create the model from the JSON string above" do
        url_mgr.stub(:content_type).and_return("application/json")
        url_mgr.stub(:body).and_return(@json)
        
        code_gen.create_models
        puts File.join(options[:model_output_dir], options[:model_file_name])
        File.exists?(File.join(options[:model_output_dir], "seasonal_era_percentile.rb")).should == true
      end
    end
  end
end
