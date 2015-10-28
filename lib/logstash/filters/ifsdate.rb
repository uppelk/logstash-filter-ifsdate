# encoding: utf-8
require "logstash/filters/base"
require "logstash/namespace"

# Add any asciidoc formatted documentation here
# This example filter will replace the contents of the default
# message field with whatever you specify in the configuration.
#
# It is only intended to be used as an example.
class LogStash::Filters::IfsDate < LogStash::Filters::Base

  # Setting the config_name here is required. This is how you
  # configure this filter from your Logstash config.
  #
  # filter {
  #   example { message => "My message..." }
  # }
  config_name "ifsdate"

  #
  config :field, :validate => :string, :required => true
  
  config :default_formats, :validate => :array

  # Store the matching timestamp into the given target field.  If not provided,
  # default to updating the `@timestamp` field of the event.
  config :target, :validate => :string, :default => "@timestamp"

  config :tag_on_failure, :validate => :array, :default => ["_ifsdateparsefailure"]
  
  @parser = {}
  
  public
  def register
	
	require "java"
	require 'dateparser.jar'
    
	# Add instance variables
	@parser = Java::test.DateParser.new()
	@parser.init()
	
	if (!default_formats.nil?)
		@parser.setDefaultFormats(default_formats)
	end
	
	#print "parser created.\n"
  end # def register

  public
  def filter(event)
	# print "filter..." + event[@field] + "\n"
    if @field
		begin
			original_value = event[@field]
			if (!original_value.nil?)
				epochmillis  = @parser.parse(original_value)
				event[@target] = LogStash::Timestamp.at(epochmillis / 1000, (epochmillis % 1000) * 1000)
				
				# filter_matched should go in the last line of our successful code
				filter_matched(event)
			end
		rescue => error
			#print "\n===============> " + error.to_s + "\n"
			#print "===============> " + error.backtrace.join("\n")
			@tag_on_failure.each do |tag|
				#print "\n===============> " + tag + "\n"
				event["tags"] ||= []
				event["tags"] << tag unless event["tags"].include?(tag)
			end
		end
    end

  end # def filter

end # class LogStash::Filters::Example