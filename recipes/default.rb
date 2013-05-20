#
# Cookbook Name:: solr
# Recipe:: default
#
#

# include epel on redhat/centos 5 and below in order to get the memcached packages
if node['platform_family'] == "rhel" and node['platform_version'].to_i < 6
 include_recipe "yum::epel"
end

case node['platform_family']
when "debian"
  package "jsvc"
  if node['platform'] == "ubuntu" && node['platform_version'].to_f >= 11
    package "openjdk-7-jdk"
  else
    package "openjdk-6-jdk"
  end
when "rhel","fedora"
  package "java-1.7.0-openjdk"
end


directory node['solr']['home'] do
  owner node['solr']['user']
  group node['solr']['group']
  mode  00755
  action :create
  recursive true
end

node['solr']['cores'].each do |core_name|

  directory "#{node['solr']['home']}/cores/#{core_name}/conf" do
    owner node['solr']['user']
    group node['solr']['group']
    mode  00755
    action :create
    recursive true
  end
  
  directory "#{node['solr']['home']}/cores/#{core_name}/data" do
    owner node['solr']['user']
    group node['solr']['group']
    mode  00755
    action :create
    recursive true
  end
  
  template "#{node['solr']['home']}/cores/#{core_name}/conf/solrconfig.xml" do
    source "solrconfig.xml.erb"
    owner node['solr']['user']
    group node['solr']['group']
    mode 0644
    variables(
      solr_home: node['solr']['home'],
      lucene_match_version: node['solr']['lucene_match_version']
    )
  end

  %w{elevate.xml mapping-ISOLatin1Accent.txt schema.xml spellings.txt stopwords.txt stopwords_en.txt synonyms.txt}.each do |conf|
    template "#{node['solr']['home']}/cores/#{core_name}/conf/#{conf}" do
      source conf
      owner node['solr']['user']
      group node['solr']['group']
      mode 0644
    end
  end

end

template "#{node['solr']['home']}/solr.xml" do
  source "solr.xml.erb"
  variables(
    cores: node['solr']['cores']
  )
  owner node['solr']['user']
  group node['solr']['group']
  mode 0644
end

# template "/etc/profile.d/solr.sh" do
#   source "solr.sh.erb"
#   variables(
#     solr_home: node['solr']['home']
#   )
#   owner node['solr']['user']
#   group node['solr']['group']
#   mode "0755"
# end

remote_file "#{Chef::Config[:file_cache_path]}/solr-#{node['solr']['version']}.tgz" do
  source node['solr']['url']
  mode "0644"
end

bash "extract solr-#{node['solr']['version']}.tgz" do
  user node['solr']['user']
  cwd Chef::Config[:file_cache_path]
  code <<-EOH
  tar xzvf solr-#{node['solr']['version']}.tgz
  EOH
end

bash "copy files" do
  user node['solr']['user']
  cwd node['solr']['home']
  code <<-EOH
    rm -rf docs licenses example dist contrib
    cp -a #{Chef::Config[:file_cache_path]}/solr-#{node['solr']['version']}/example ./
    cp -a #{Chef::Config[:file_cache_path]}/solr-#{node['solr']['version']}/dist ./
    cp -a #{Chef::Config[:file_cache_path]}/solr-#{node['solr']['version']}/contrib ./
    cp dist/solr-#{node['solr']['version']}.war solr.war
  EOH
end
