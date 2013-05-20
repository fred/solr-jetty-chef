Solr Cookbook
=============

Installs latest Solr from tar file downloaded from Lucene.

It creates /etc/profiles.d/solr.sh with proper env variables and setup Solr cores.

For now, it's using conservative settings for cores, such as caching and memory.
In the future I plan to let those be customized.

Default installation directory is /usr/local/Solr/Home

Enabled Features:

- Autocommit every 60 seconds
- SoftAutocommit every 5 seconds
- Document cache 5120
- Search Filter cache 5120

Tested on:

- Solr 4.3.0
- Jetty 9.0.3


Requirements
------------

- openJDK


Attributes
----------

#### solr::default
<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['solr']['version']</tt></td>
    <td>String</td>
    <td>Version of Solr to download</td>
    <td><tt>4.2.0</tt></td>
  </tr>
  <tr>
    <td><tt>['solr']['directory']</tt></td>
    <td>String</td>
    <td>Installation directory for Solr</td>
    <td><tt>/usr/local/Solr/Home</tt></td>
  </tr>
    <tr>
    <td><tt>['solr']['user']</tt></td>
    <td>String</td>
    <td>Owner of Solr installation directory</td>
    <td><tt>root</tt></td>
  </tr>
  </tr>
    <tr>
    <td><tt>['solr']['core']</tt></td>
    <td>Array</td>
    <td>Array of solr cores to create</td>
    <td><tt>['core1', 'core2']</tt></td>
  </tr>
</table>


Usage
-----

#### solr::default

e.g.
Just include `solr` in your node's `run_list`:

```json
{
  "run_list": [
    "recipe[solr]"
  ]
}
```

Contributing
------------

e.g.
1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write you change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github


License and Authors
-------------------

Authors: Frederico Araujo
