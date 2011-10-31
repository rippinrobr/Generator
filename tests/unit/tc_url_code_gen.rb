$:<< './lib'
require 'test/unit'
require 'mocha'
require 'generator/sources/url/url_code_gen'

puts Dir.pwd

module Ruby
class UrlCodeGenTest < Test::Unit::TestCase

  def setup 
    @body_json = %Q(
  {
  "offset" : 0,
  "rows": [
    { "_id" : { "$oid" : "4e9de233fc56e5daf5ba03e6" }, "franchID" : "ALT", "franchName" : "Altoona Mountain City", "active" : "N" } ,
    { "_id" : { "$oid" : "4e9de233fc56e5daf5ba03e7" }, "franchID" : "ANA", "franchName" : "Los Angeles Angels of Anaheim", "active" : "Y" } ,
    { "_id" : { "$oid" : "4e9de233fc56e5daf5ba03e8" }, "franchID" : "ARI", "franchName" : "Arizona Diamondbacks", "active" : "Y" } ,
    { "_id" : { "$oid" : "4e9de233fc56e5daf5ba03e9" }, "franchID" : "ATH", "franchName" : "Philadelphia Athletics", "active" : "N", "NAassoc" : "PNA" } ,
    { "_id" : { "$oid" : "4e9de233fc56e5daf5ba03ea" }, "franchID" : "ATL", "franchName" : "Atlanta Braves", "active" : "Y", "NAassoc" : "BNA" } ,
    { "_id" : { "$oid" : "4e9de233fc56e5daf5ba03eb" }, "franchID" : "BAL", "franchName" : "Baltimore Orioles", "active" : "Y" } ,
    { "_id" : { "$oid" : "4e9de233fc56e5daf5ba03ec" }, "franchID" : "BFB", "franchName" : "Buffalo Bisons", "active" : "N" } ,
    { "_id" : { "$oid" : "4e9de233fc56e5daf5ba03ed" }, "franchID" : "BFL", "franchName" : "Buffalo Bisons", "active" : "N" } ,
    { "_id" : { "$oid" : "4e9de233fc56e5daf5ba03ee" }, "franchID" : "BLC", "franchName" : "Baltimore Canaries", "active" : "NA" } ,
    { "_id" : { "$oid" : "4e9de233fc56e5daf5ba03ef" }, "franchID" : "BLO", "franchName" : "Baltimore Orioles", "active" : "N" } ,
    { "_id" : { "$oid" : "4e9de233fc56e5daf5ba03f0" }, "franchID" : "BLT", "franchName" : "Baltimore Terrapins", "active" : "N" } ,
    { "_id" : { "$oid" : "4e9de233fc56e5daf5ba03f1" }, "franchID" : "BLU", "franchName" : "Baltimore Monumentals", "active" : "N" } ,
    { "_id" : { "$oid" : "4e9de233fc56e5daf5ba03f2" }, "franchID" : "BNA", "franchName" : "Boston Red Stockings", "active" : "NA", "NAassoc" : "ATL" } ,
    { "_id" : { "$oid" : "4e9de233fc56e5daf5ba03f3" }, "franchID" : "BOS", "franchName" : "Boston Red Sox", "active" : "Y" } ,
    { "_id" : { "$oid" : "4e9de233fc56e5daf5ba03f4" }, "franchID" : "BRA", "franchName" : "Brooklyn Atlantics", "active" : "NA" } ,
    { "_id" : { "$oid" : "4e9de233fc56e5daf5ba03f5" }, "franchID" : "BRD", "franchName" : "Boston Reds", "active" : "N" } ,
    { "_id" : { "$oid" : "4e9de233fc56e5daf5ba03f6" }, "franchID" : "BRG", "franchName" : "Brooklyn Gladiators", "active" : "N" } ,
    { "_id" : { "$oid" : "4e9de233fc56e5daf5ba03f7" }, "franchID" : "BRS", "franchName" : "Boston Reds", "active" : "N" } ,
    { "_id" : { "$oid" : "4e9de233fc56e5daf5ba03f8" }, "franchID" : "BTT", "franchName" : "Brooklyn Tip-Tops", "active" : "N" } ,
    { "_id" : { "$oid" : "4e9de233fc56e5daf5ba03f9" }, "franchID" : "BUF", "franchName" : "Buffalo Bisons", "active" : "N" } ,
    { "_id" : { "$oid" : "4e9de233fc56e5daf5ba03fa" }, "franchID" : "BWW", "franchName" : "Brooklyn Ward's Wonders", "active" : "N" } ,
    { "_id" : { "$oid" : "4e9de233fc56e5daf5ba03fb" }, "franchID" : "CBK", "franchName" : "Columbus Buckeyes", "active" : "N" } ,
    { "_id" : { "$oid" : "4e9de233fc56e5daf5ba03fc" }, "franchID" : "CBL", "franchName" : "Cleveland Blues", "active" : "N" } ,
    { "_id" : { "$oid" : "4e9de233fc56e5daf5ba03fd" }, "franchID" : "CEN", "franchName" : "Philadelphia Centennials", "active" : "NA" } ,
    { "_id" : { "$oid" : "4e9de233fc56e5daf5ba03fe" }, "franchID" : "CFC", "franchName" : "Cleveland Forest Citys", "active" : "NA" } ,
    { "_id" : { "$oid" : "4e9de233fc56e5daf5ba03ff" }, "franchID" : "CHC", "franchName" : "Chicago Cubs", "active" : "Y", "NAassoc" : "CNA" } ,
    { "_id" : { "$oid" : "4e9de233fc56e5daf5ba0400" }, "franchID" : "CHH", "franchName" : "Chicago Whales", "active" : "N" } ,
    { "_id" : { "$oid" : "4e9de233fc56e5daf5ba0401" }, "franchID" : "CHP", "franchName" : "Chicago Pirates", "active" : "N" } ,
    { "_id" : { "$oid" : "4e9de233fc56e5daf5ba0402" }, "franchID" : "CHW", "franchName" : "Chicago White Sox", "active" : "Y" } ,
    { "_id" : { "$oid" : "4e9de233fc56e5daf5ba0403" }, "franchID" : "CIN", "franchName" : "Cincinnati Reds", "active" : "Y" } ,
    { "_id" : { "$oid" : "4e9de233fc56e5daf5ba0404" }, "franchID" : "CKK", "franchName" : "Cincinnati Kelly's Killers", "active" : "N" } ,
    { "_id" : { "$oid" : "4e9de233fc56e5daf5ba0405" }, "franchID" : "CLE", "franchName" : "Cleveland Indians", "active" : "Y" } ,
    { "_id" : { "$oid" : "4e9de233fc56e5daf5ba0406" }, "franchID" : "CLI", "franchName" : "Cleveland Infants", "active" : "N" } ,
    { "_id" : { "$oid" : "4e9de233fc56e5daf5ba0407" }, "franchID" : "CLS", "franchName" : "Columbus Solons", "active" : "N" } ,
    { "_id" : { "$oid" : "4e9de233fc56e5daf5ba0408" }, "franchID" : "CLV", "franchName" : "Cleveland Spiders", "active" : "N" } ,
    { "_id" : { "$oid" : "4e9de233fc56e5daf5ba0409" }, "franchID" : "CNA", "franchName" : "Chicago White Stockings", "active" : "NA", "NAassoc" : "CHC" } ,
    { "_id" : { "$oid" : "4e9de233fc56e5daf5ba040a" }, "franchID" : "CNR", "franchName" : "Cincinnati Reds", "active" : "N" } ,
    { "_id" : { "$oid" : "4e9de233fc56e5daf5ba040b" }, "franchID" : "COL", "franchName" : "Colorado Rockies", "active" : "Y" } ,
    { "_id" : { "$oid" : "4e9de233fc56e5daf5ba040c" }, "franchID" : "COR", "franchName" : "Cincinnati Outlaw Reds", "active" : "N" } ,
    { "_id" : { "$oid" : "4e9de233fc56e5daf5ba040d" }, "franchID" : "CPI", "franchName" : "Chicago/Pittsburgh (Union League)", "active" : "N" } ,
    { "_id" : { "$oid" : "4e9de233fc56e5daf5ba040e" }, "franchID" : "DET", "franchName" : "Detroit Tigers", "active" : "Y" } ,
    { "_id" : { "$oid" : "4e9de233fc56e5daf5ba040f" }, "franchID" : "DTN", "franchName" : "Detroit Wolverines", "active" : "N" } ,
    { "_id" : { "$oid" : "4e9de233fc56e5daf5ba0410" }, "franchID" : "ECK", "franchName" : "Brooklyn Eckfords", "active" : "NA" } ,
    { "_id" : { "$oid" : "4e9de233fc56e5daf5ba0411" }, "franchID" : "FLA", "franchName" : "Florida Marlins", "active" : "Y" } ,
    { "_id" : { "$oid" : "4e9de233fc56e5daf5ba0412" }, "franchID" : "HAR", "franchName" : "Hartford Dark Blues", "active" : "N", "NAassoc" : "HNA" } ,
    { "_id" : { "$oid" : "4e9de233fc56e5daf5ba0413" }, "franchID" : "HNA", "franchName" : "Hartford Dark Blues", "active" : "NA", "NAassoc" : "HAR" } ,
    { "_id" : { "$oid" : "4e9de233fc56e5daf5ba0414" }, "franchID" : "HOU", "franchName" : "Houston Astros", "active" : "Y" } ,
    { "_id" : { "$oid" : "4e9de233fc56e5daf5ba0415" }, "franchID" : "IBL", "franchName" : "Indianapolis Blues", "active" : "N" } ,
    { "_id" : { "$oid" : "4e9de233fc56e5daf5ba0416" }, "franchID" : "IHO", "franchName" : "Indianapolis Hoosiers", "active" : "N" } ,
    { "_id" : { "$oid" : "4e9de233fc56e5daf5ba0417" }, "franchID" : "IND", "franchName" : "Indianapolis Hoosiers", "active" : "N" } ,
    { "_id" : { "$oid" : "4e9de233fc56e5daf5ba0418" }, "franchID" : "KCC", "franchName" : "Kansas City Cowboys", "active" : "N" } ,
    { "_id" : { "$oid" : "4e9de233fc56e5daf5ba0419" }, "franchID" : "KCN", "franchName" : "Kansas City Cowboys", "active" : "N" } ,
    { "_id" : { "$oid" : "4e9de233fc56e5daf5ba041a" }, "franchID" : "KCP", "franchName" : "Kansas City Packers", "active" : "N" } ,
    { "_id" : { "$oid" : "4e9de233fc56e5daf5ba041b" }, "franchID" : "KCR", "franchName" : "Kansas City Royals", "active" : "Y" } ,
    { "_id" : { "$oid" : "4e9de233fc56e5daf5ba041c" }, "franchID" : "KCU", "franchName" : "Kansas City Cowboys", "active" : "N" } ,
    { "_id" : { "$oid" : "4e9de233fc56e5daf5ba041d" }, "franchID" : "KEK", "franchName" : "Fort Wayne Kekiongas", "active" : "NA" } ,
    { "_id" : { "$oid" : "4e9de233fc56e5daf5ba041e" }, "franchID" : "LAD", "franchName" : "Los Angeles Dodgers", "active" : "Y" } ,
    { "_id" : { "$oid" : "4e9de233fc56e5daf5ba041f" }, "franchID" : "LGR", "franchName" : "Louisville Grays", "active" : "N" } ,
    { "_id" : { "$oid" : "4e9de233fc56e5daf5ba0420" }, "franchID" : "LOU", "franchName" : "Louisville Colonels", "active" : "N" } ,
    { "_id" : { "$oid" : "4e9de233fc56e5daf5ba0421" }, "franchID" : "MAN", "franchName" : "Middletown Mansfields", "active" : "NA" } ,
    { "_id" : { "$oid" : "4e9de233fc56e5daf5ba0422" }, "franchID" : "MAR", "franchName" : "Baltimore Marylands", "active" : "NA" } ,
    { "_id" : { "$oid" : "4e9de233fc56e5daf5ba0423" }, "franchID" : "MIL", "franchName" : "Milwaukee Brewers", "active" : "Y" } ,
    { "_id" : { "$oid" : "4e9de233fc56e5daf5ba0424" }, "franchID" : "MIN", "franchName" : "Minnesota Twins", "active" : "Y" } ,
    { "_id" : { "$oid" : "4e9de233fc56e5daf5ba0425" }, "franchID" : "MLA", "franchName" : "Milwaukee Brewers", "active" : "N" } ,
    { "_id" : { "$oid" : "4e9de233fc56e5daf5ba0426" }, "franchID" : "MLG", "franchName" : "Milwaukee Grays", "active" : "N" } ,
    { "_id" : { "$oid" : "4e9de233fc56e5daf5ba0427" }, "franchID" : "MLU", "franchName" : "Milwaukee Brewers", "active" : "N" } ,
    { "_id" : { "$oid" : "4e9de233fc56e5daf5ba0428" }, "franchID" : "NAT", "franchName" : "Washington Nationals", "active" : "NA" } ,
    { "_id" : { "$oid" : "4e9de233fc56e5daf5ba0429" }, "franchID" : "NEW", "franchName" : "Newark Pepper", "active" : "N" } ,
    { "_id" : { "$oid" : "4e9de233fc56e5daf5ba042a" }, "franchID" : "NHV", "franchName" : "New Haven Elm Citys", "active" : "NA" } ,
    { "_id" : { "$oid" : "4e9de233fc56e5daf5ba042b" }, "franchID" : "NNA", "franchName" : "New York Mutuals", "active" : "NA", "NAassoc" : "NYU" } ,
    { "_id" : { "$oid" : "4e9de233fc56e5daf5ba042c" }, "franchID" : "NYI", "franchName" : "New York Giants", "active" : "N" } ,
    { "_id" : { "$oid" : "4e9de233fc56e5daf5ba042d" }, "franchID" : "NYM", "franchName" : "New York Mets", "active" : "Y" } ,
    { "_id" : { "$oid" : "4e9de233fc56e5daf5ba042e" }, "franchID" : "NYP", "franchName" : "New York Metropolitans", "active" : "N" } ,
    { "_id" : { "$oid" : "4e9de233fc56e5daf5ba044e" }, "franchID" : "TEX", "franchName" : "Texas Rangers", "active" : "Y" } ,
    { "_id" : { "$oid" : "4e9de233fc56e5daf5ba042f" }, "franchID" : "NYU", "franchName" : "New York Mutuals", "active" : "N", "NAassoc" : "NNA" } ,
    { "_id" : { "$oid" : "4e9de233fc56e5daf5ba0430" }, "franchID" : "NYY", "franchName" : "New York Yankees", "active" : "Y" } ,
    { "_id" : { "$oid" : "4e9de233fc56e5daf5ba0431" }, "franchID" : "OAK", "franchName" : "Oakland Athletics", "active" : "Y" } ,
    { "_id" : { "$oid" : "4e9de233fc56e5daf5ba0432" }, "franchID" : "OLY", "franchName" : "Washington Olympics", "active" : "NA" } ,
    { "_id" : { "$oid" : "4e9de233fc56e5daf5ba0433" }, "franchID" : "PBB", "franchName" : "Pittsburgh Burghers", "active" : "N" } ,
    { "_id" : { "$oid" : "4e9de233fc56e5daf5ba0434" }, "franchID" : "PBS", "franchName" : "Pittsburgh Rebels", "active" : "N" } ,
    { "_id" : { "$oid" : "4e9de233fc56e5daf5ba0435" }, "franchID" : "PHA", "franchName" : "Philadelphia Athletics", "active" : "N" } ,
    { "_id" : { "$oid" : "4e9de233fc56e5daf5ba0436" }, "franchID" : "PHI", "franchName" : "Philadelphia Phillies", "active" : "Y" } ,
    { "_id" : { "$oid" : "4e9de233fc56e5daf5ba0437" }, "franchID" : "PHK", "franchName" : "Philadelphia Keystones", "active" : "N" } ,
    { "_id" : { "$oid" : "4e9de233fc56e5daf5ba0438" }, "franchID" : "PHQ", "franchName" : "Philadelphia Athletics", "active" : "N" } ,
    { "_id" : { "$oid" : "4e9de233fc56e5daf5ba0439" }, "franchID" : "PIT", "franchName" : "Pittsburgh Pirates", "active" : "Y" } ,
    { "_id" : { "$oid" : "4e9de233fc56e5daf5ba043a" }, "franchID" : "PNA", "franchName" : "Philadelphia Athletics", "active" : "NA", "NAassoc" : "ATH" } ,
    { "_id" : { "$oid" : "4e9de233fc56e5daf5ba043b" }, "franchID" : "PRO", "franchName" : "Providence Grays", "active" : "N" } ,
    { "_id" : { "$oid" : "4e9de233fc56e5daf5ba043c" }, "franchID" : "PWS", "franchName" : "Philadelphia White Stockings", "active" : "NA" } ,
    { "_id" : { "$oid" : "4e9de233fc56e5daf5ba043d" }, "franchID" : "RES", "franchName" : "Elizabeth Resolutes", "active" : "NA" } ,
    { "_id" : { "$oid" : "4e9de233fc56e5daf5ba043e" }, "franchID" : "RIC", "franchName" : "Richmond Virginians", "active" : "N" } ,
    { "_id" : { "$oid" : "4e9de233fc56e5daf5ba043f" }, "franchID" : "ROC", "franchName" : "Rochester Broncos", "active" : "N" } ,
    { "_id" : { "$oid" : "4e9de233fc56e5daf5ba0440" }, "franchID" : "ROK", "franchName" : "Rockford Forest Citys", "active" : "NA" } ,
    { "_id" : { "$oid" : "4e9de233fc56e5daf5ba0441" }, "franchID" : "SBS", "franchName" : "St. Louis Brown Stockings", "active" : "N", "NAassoc" : "SNA" } ,
    { "_id" : { "$oid" : "4e9de233fc56e5daf5ba0442" }, "franchID" : "SDP", "franchName" : "San Diego Padres", "active" : "Y" } ,
    { "_id" : { "$oid" : "4e9de233fc56e5daf5ba0443" }, "franchID" : "SEA", "franchName" : "Seattle Mariners", "active" : "Y" } ,
    { "_id" : { "$oid" : "4e9de233fc56e5daf5ba0444" }, "franchID" : "SFG", "franchName" : "San Francisco Giants", "active" : "Y" } ,
    { "_id" : { "$oid" : "4e9de233fc56e5daf5ba0445" }, "franchID" : "SLI", "franchName" : "St. Louis Terriers", "active" : "N" } ,
    { "_id" : { "$oid" : "4e9de233fc56e5daf5ba0446" }, "franchID" : "SLM", "franchName" : "St. Louis Maroons", "active" : "N" } ,
    { "_id" : { "$oid" : "4e9de233fc56e5daf5ba0447" }, "franchID" : "SLR", "franchName" : "St. Louis Red Stockings", "active" : "NA" } ,
    { "_id" : { "$oid" : "4e9de233fc56e5daf5ba0448" }, "franchID" : "SNA", "franchName" : "St. Louis Brown Stockings", "active" : "NA", "NAassoc" : "SBS" } ,
    { "_id" : { "$oid" : "4e9de233fc56e5daf5ba0449" }, "franchID" : "STL", "franchName" : "St. Louis Cardinals", "active" : "Y" } ,
    { "_id" : { "$oid" : "4e9de233fc56e5daf5ba044a" }, "franchID" : "STP", "franchName" : "St. Paul Apostles", "active" : "N" } ,
    { "_id" : { "$oid" : "4e9de233fc56e5daf5ba044b" }, "franchID" : "SYR", "franchName" : "Syracuse Stars", "active" : "N" } ,
    { "_id" : { "$oid" : "4e9de233fc56e5daf5ba044c" }, "franchID" : "SYS", "franchName" : "Syracuse Stars", "active" : "N" } ,
    { "_id" : { "$oid" : "4e9de233fc56e5daf5ba044d" }, "franchID" : "TBD", "franchName" : "Tampa Bay Rays", "active" : "Y" } ,
    { "_id" : { "$oid" : "4e9de233fc56e5daf5ba044f" }, "franchID" : "TLM", "franchName" : "Toledo Maumees", "active" : "N" } ,
    { "_id" : { "$oid" : "4e9de233fc56e5daf5ba0450" }, "franchID" : "TOL", "franchName" : "Toledo Blue Stockings", "active" : "N" } ,
    { "_id" : { "$oid" : "4e9de233fc56e5daf5ba0451" }, "franchID" : "TOR", "franchName" : "Toronto Blue Jays", "active" : "Y" } ,
    { "_id" : { "$oid" : "4e9de233fc56e5daf5ba0452" }, "franchID" : "TRO", "franchName" : "Troy Haymakers", "active" : "NA" } ,
    { "_id" : { "$oid" : "4e9de233fc56e5daf5ba0453" }, "franchID" : "TRT", "franchName" : "Troy Trojans", "active" : "N" } ,
    { "_id" : { "$oid" : "4e9de233fc56e5daf5ba0454" }, "franchID" : "WAS", "franchName" : "Washington Senators", "active" : "N" } ,
    { "_id" : { "$oid" : "4e9de233fc56e5daf5ba0455" }, "franchID" : "WBL", "franchName" : "Washington Blue Legs", "active" : "NA" } ,
    { "_id" : { "$oid" : "4e9de233fc56e5daf5ba0456" }, "franchID" : "WES", "franchName" : "Keokuk Westerns", "active" : "NA" } ,
    { "_id" : { "$oid" : "4e9de233fc56e5daf5ba0457" }, "franchID" : "WIL", "franchName" : "Wilmington Quicksteps", "active" : "N" } ,
    { "_id" : { "$oid" : "4e9de233fc56e5daf5ba0458" }, "franchID" : "WNA", "franchName" : "Washington Nationals", "active" : "N" } ,
    { "_id" : { "$oid" : "4e9de233fc56e5daf5ba0459" }, "franchID" : "WNL", "franchName" : "Washington Nationals", "active" : "N" } ,
    { "_id" : { "$oid" : "4e9de233fc56e5daf5ba045a" }, "franchID" : "WNT", "franchName" : "Washington Nationals", "active" : "NA" } ,
    { "_id" : { "$oid" : "4e9de233fc56e5daf5ba045b" }, "franchID" : "WOR", "franchName" : "Worcester Ruby Legs", "active" : "N" } ,
    { "_id" : { "$oid" : "4e9de233fc56e5daf5ba045c" }, "franchID" : "WSN", "franchName" : "Washington Nationals", "active" : "Y" } ,
    { "_id" : { "$oid" : "4e9de233fc56e5daf5ba045d" }, "franchID" : "WST", "franchName" : "Washington Statesmen", "active" : "N" }
  ],

  "total_rows" : 120 ,
  "query" : {} ,
  "millis" : 2
}
)
  @options = Hash.new
  @options[:input_type] = "url"
  @options[:language] = "ruby"
  @options[:header] = false
  @options[:source_file] = "http://127.0.0.1:28017/bdb/franchises/"
  @options[:url] = "http://127.0.0.1:28017/bdb/franchises/"
  @options[:content_type] = "application_json"
  @options[:model_output_dir] = "/tmp"
  @options[:model_class_name] = "test_model"
end

 def test_should_return_create_two_models
   res = mock()
   res.expects(:content_type).at_least_once.returns('text/plain')
   res.expects(:body).returns(@body_json)

   url_mgr = mock()
   url_mgr.expects(:get_page).returns(res)
   
   gen = Generator::Engine.new @options, url_mgr
   classes = gen.create_models
   classes.map do |c|
     full_path = "#{@options[:model_output_dir]}/#{c.name}.rb"
     assert(File.exists?(full_path), "#{full_path} was not created")
   end 
   assert_equal(2, classes.length)
  
 end
end
end
