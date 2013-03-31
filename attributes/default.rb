# Default settings

default['solr']['version'] = '4.2.0'
default['solr']['url']  = "http://apache.claz.org/lucene/solr/#{node['solr']['version']}/solr-#{node['solr']['version']}.tgz"
# default['solr']['url']  = "http://192.168.56.1/solr-#{node['solr']['version']}.tgz"
default['solr']['home'] = "/usr/local/Solr/Home"
default['solr']['user'] = 'fred'
default['solr']['group'] = 'staff'

# default['solr']['cores'] = %w{core1 core2 core3}
default['solr']['cores'] = [
  "realestate_production",
  "realestate_development",
  "realestate_rest",
  "mnn_production",
  "mnn_development",
  "mnn_test"
]

default['solr']['lucene_match_version'] = "LUCENE_CURRENT"

# use 8.1.9.v20130131 if you need Java6 support
default["jetty"]["source"]["version"]  = "9.0.0.v20130308"
default['jetty']['source']['checksum'] = "d79a0b5d731cbc7306823b7b0c4e2c373af24f0241bd85a"

default['jetty']['home']  = "/usr/local/Jetty/Home"
default['jetty']['user']  = 'ubuntu'
default['jetty']['group'] = 'ubuntu'
default["jetty"]["host"]  = "0.0.0.0"
default["jetty"]["port"]  = 8080
default["jetty"]["no_start"]     = 0
default["jetty"]["jetty_args"]   = ""
# default["jetty"]["jetty_args"] = #{node['jetty']['home']}/etc/jetty-plus.xml"
default["jetty"]["java_options"] = "-Xms64m -Xmx400m -server -d64 -Djava.awt.headless=true -XX:+UseSerialGC -XX:+AggressiveOpts -XX:+UseBiasedLocking -Dsolr.solr.home=#{node['solr']['home']}"

