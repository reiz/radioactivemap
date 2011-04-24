# == Schema Information
# Schema version: 20110423215318
#
# Table name: akws
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  link       :string(255)
#  akwtype    :string(255)
#  status     :string(255)
#  lat        :string(255)
#  lng        :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Akw < ActiveRecord::Base

  def self.load_file
    filename = 'akws.csv'
    file = File.new(filename, 'r')
    file.each_line("\n") do |row|
      columns = row.split(",")
      akw = Akw.new
      akw.name = columns[0]
      akw.link = columns[1]
      akw.akwtype = columns[2]
      akw.status = columns[3]
      akw.lat = columns[4]
      akw.lng = columns[5]
      akw.save
    end
  end

  def self.parse_xml
    xml = File.read('akw-table.html')
    doc = REXML::Document.new(xml)
    doc.elements.each('tbody/tr') do |s|
      akw = Akw.new
      akw.name = s.elements[1].elements[1].text
      akw.link = s.elements[1].elements[1].attributes['href']
      akw.akwtype = s.elements[2].text
      akw.status = s.elements[4].text
      akw.save
    end
  end

  def self.crawler
    akws = Akw.all
    akws.each do |akw|
      partlink = akw.link
      parts = partlink.split('rid=')
      url = 'http://www.world-nuclear.org/NuclearDatabase/popmap.aspx?rid=' + parts[1]
      response = HTTParty.get(url).response.body
      parts = response.split('var point = new GLatLng(')
      part1 = parts[1]
      parts2 = part1.split(');')
      latlng = parts2[0]
      latlnglist = latlng.split(', ')
      akw.lat = latlnglist[0]
      akw.lng = latlnglist[1]
      akw.save
    end
  end

  def full_link
    url = "http://www.world-nuclear.org/NuclearDatabase/" + self.link if !self.link.nil?
    url = "http://www.world-nuclear.org/" if self.link.nil?
    url
  end

end
