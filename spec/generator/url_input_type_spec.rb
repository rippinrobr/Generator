require 'spec_helper'
require_relative '../../lib/generator/sources/url/url_code_gen.rb'
require_relative '../../lib/generator/utils/url_manager'

module Generator
  describe Engine do
    before(:all) do 
      @json = "\"{ \"Season\": \"1979\",  \"Position\": \"P\",  \"League\": \"AL\",  \"Rankings\": [{ \"Rank\": \"5\",  \"Value\": \"9\"},{ \"Rank\": \"15\",  \"Value\": \"6.38931297709924\"},{ \"Rank\": \"55\",  \"Value\": \"4.21723518850987\"},{ \"Rank\": \"85\",  \"Value\": \"3.12631578947368\"},{ \"Rank\": \"95\",  \"Value\": \"1.57342657342657\"}]}\""

      @complicated_json = '{ "data": { "Season": "1979",  "Position": "P",  "League": "AL",  "Rankings": [{ "Rank": "5",  "Value": "9"},{ "Rank": "15",  "Value": "6.38931297709924"},{ "Rank": "55",  "Value": "4.21723518850987"},{ "Rank": "85",  "Value": "3.12631578947368"},{ "Rank": "95",  "Value": "1.57342657342657"}]}, "meta": {"usermeta":{},"debug":true,"api":"http","clientId":"riak-js", "binary":false,"raw":"riak","contentEncoding":"utf8","links":[],"host":"localhost","accept":"multipart/mixed, application/json;q=0.7, */*;q=0.5","responseEncoding":"utf8","bucket":"era_percentile","key":"1979_AL","contentType":"application/json","vclock":"a85hYGBgzGDKBVIsbDK5pzKYEhnzWBm4lhw+xpcFAA==","lastMod":"Sun, 06 Feb 2011 23:00:26 GMT","etag":"\"7mdYrNZ3cSvSeRo3DdOAaF\"","statusCode":200}, "error": {}}'
    end
      
    let(:options) { { :url => 'http://localhost:8098/riak/era_percentile/1979_AL', :language => 'ruby', :model_class_name => 'seasonal_era_percentile', :model_file_name => '1979_al.rb', :model_output_dir => '/tmp', :service_file_name => '1979_al_service.rb', :service_output_dir => '/tmp/ruby/service', :model_output => :src, :input_type => 'url', :service_class_name => 'seasonal_era_percentile_service' } }
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

    describe "#create ruby class files" do
      it "should be able to create a ruby model from the JSON string above" do
        url_mgr.stub(:content_type).and_return("application/json")
        url_mgr.stub(:body).and_return(@json)
        
        code_gen.create_models
        File.exists?(File.join(options[:model_output_dir], "seasonal_era_percentile.rb")).should == true
      end

      it "should create a ruby service class from the JSON string above" do
        url_mgr.stub(:content_type).and_return("application/json")
        url_mgr.stub(:body).and_return(@json)
       
        code_gen.create_models
        code_gen.create_service_classes 
        File.exists?(File.join(options[:service_output_dir], "seasonal_era_percentile_service.rb")).should == true
      end

      it "should create multiple classes for JSON objects that have multiple classes in them" do
        url_mgr.stub(:content_type).and_return("application/json")
        url_mgr.stub(:body).and_return(@complicated_json)
        options[:model_class_name] = "node_seasonal_era_percentile"        

        code_gen.create_models
        File.exists?(File.join(options[:model_output_dir], "node_seasonal_era_percentile.rb")).should == true
      end
      it "should create service class for JSON objects that have multiple classes in them", :ruby_service => true do
        url_mgr.stub(:content_type).and_return("application/json")
        url_mgr.stub(:body).and_return(@complicated_json)

        code_gen.create_models
        code_gen.create_service_classes
        File.exists?(File.join(options[:service_output_dir], "seasonal_era_percentile_service.rb")).should == true
      end
    end
    
    describe "#create C# class files" do
      let(:options) { { :url => 'http://localhost:8098/riak/era_percentile/1979_AL', :language => 'c_sharp', :model_class_name => 'seasonal_era_percentile', :model_file_name => '1979_al.rb', :model_output_dir => '/tmp', :service_file_name => '1979_al_service.rb', :service_output_dir => '/tmp', :model_output => :src, :model_namespace => 'StatsDriven.StatisPro', :input_type => 'url', :service_class_name => 'seasonal_era_percentile_service' } }
      it "should create a C# model from the JSON string" do
        url_mgr.stub(:content_type).and_return("application/json")
        url_mgr.stub(:body).and_return(@json)
        
        code_gen.create_models
        puts File.join(options[:model_output_dir], options[:model_file_name])
        File.exists?(File.join(options[:model_output_dir], "SeasonalEraPercentile.cs")).should == true
      end

      it "should create a C# service class from the JSON string above" do
        url_mgr.stub(:content_type).and_return("application/json")
        url_mgr.stub(:body).and_return(@json)
       
        code_gen.create_models
        code_gen.create_service_classes 
        File.exists?(File.join(options[:service_output_dir], "SeasonalEraPercentileService.cs")).should == true
      end
    end
  end
end
