# Default settings

default['solr']['version'] = '4.3.0'
default['solr']['url']  = "http://apache.claz.org/lucene/solr/#{node['solr']['version']}/solr-#{node['solr']['version']}.tgz"
# default['solr']['url']  = "http://192.168.5.9/solr-#{node['solr']['version']}.tgz"
default['solr']['home'] = "/usr/local/Solr/Home"
default['solr']['user'] = 'root'
default['solr']['group'] = 'root'

# default['solr']['cores'] = %w{core1 core2 core3}
default['solr']['cores'] = [
  "realestate_production",
  "realestate_development",
  "realestate_test",
  "mnn_production",
  "mnn_development",
  "mnn_test"
]

default['solr']['lucene_match_version'] = "LUCENE_CURRENT"

# use 8.1.9.v20130131 if you need Java6 support
default["jetty"]["source"]["version"]  = "9.1.0.v20131115"
default['jetty']['source']['checksum'] = "aa91d5629c325e6fc87bf562c480d04ed36d8783"

version = node['jetty']['source']['version']
# default['jetty']['source']['url'] = "http://192.168.5.9/jetty-distribution-#{version}.tar.gz"
default['jetty']['source']['url'] = "http://download.eclipse.org/jetty/#{version}/dist/jetty-distribution-#{version}.tar.gz"

default['jetty']['home']  = "/usr/local/Jetty/Home"
default['jetty']['user']  = 'root'
default['jetty']['group'] = 'root'
default["jetty"]["host"]  = "0.0.0.0"
default["jetty"]["port"]  = 8080
default["jetty"]["no_start"]     = 0
default["jetty"]["jetty_args"]   = ""
# default["jetty"]["jetty_args"] = #{node['jetty']['home']}/etc/jetty-plus.xml"
default["jetty"]["java_options"] = "-Xms64m -Xmx360m -server -d64 -Djava.awt.headless=true -XX:+UseSerialGC -XX:+AggressiveOpts -XX:+UseBiasedLocking -Dsolr.solr.home=#{node['solr']['home']}"

