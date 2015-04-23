#!/usr/bin/env ruby

require 'plist'

module Sigh
  class ProfileAnalyser
    def self.run(path)
      plist = Plist::parse_xml(`security cms -D -i '#{path}'`)
      if plist.count > 10
        #Helper.log.info("Provisioning profile of app '#{plist['AppIDName']}' with the name '#{plist['Name']}' successfully generated and analysed.".green)
        return plist["UUID"]
      else
        #Helper.log.error("Error parsing provisioning profile at path '#{path}'".red)
      end
    end
  end
end

puts Sigh::ProfileAnalyser.run(ARGV[0])