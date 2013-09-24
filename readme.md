## Spec for solo project week 1
### End point:
Dynamic tiler to display [ascii grids and shapefiles]

### Steps:
* Explore [Windshaft](https://github.com/CartoDB/Windshaft) (a dynamic tiler written in node.js)
* Requires lots of stuff, but then should be "easy install" with [npm](https://npmjs.org/)
* Play with example
* ASCII grid requires some additional rendering (??) - not sure

### Questions
* Wasn't the point to learn about TileMill/MapBox ? Does this help?
* yes, forget Windshaft and all the crap documentation and requiring Mapnik 2.0, try Tilemill, then get XML and use with Mapnik and stache

### Approach
* Generally followed this: http://www.axismaps.com/blog/2012/01/dont-panic-an-absolute-beginners-guide-to-building-a-map-server/
* Took notes but forgot to save them


### some notes on the installation

**POSTGRES/POSTGIS:**
PRIMARY SOURCE: http://www.axismaps.com/blog/2012/01/dont-panic-an-absolute-beginners-guide-to-building-a-map-server/

* create a user within the database that can access maps:

```
createuser -SdRP gisuser
```
* Enter a password for connecting to the database, create and configure a database to hold your spatial data:

```
createdb -E UTF8 -O gisuser gis
psql -d gis -f /usr/share/postgresql/9.1/contrib/postgis-1.5/postgis.sql
psql -d gis -f /usr/share/postgresql/9.1/contrib/postgis-1.5/spatial_ref_sys.sql
psql gis -c "ALTER TABLE geometry_columns OWNER TO gisuser"
psql gis -c "ALTER TABLE spatial_ref_sys OWNER TO gisuser"
exit
```

* Configure access to database by editing the access file:

```
sudo nano /etc/postgresql/9.1/main/pg_hba.conf
```

Scroll down to the bottom of the file and change the words ident and md5 to “trust” (there should be 3). [NOTE: I found nothing with "ident" in this file.]

Addition: I had to add the following to the bottom to get this to work

```
local all gisuser trust
```

If you want to connect to this database remotely (to view your data in an external manager or view it in QGIS) you should add the line:

```
# Enable remote connections:
host    all         all         0.0.0.0/0             md5
```

to the bottom of the file and then save and close.

You’ll also need to enable remote listening by editing the main configuration file here:

```
sudo nano /etc/postgresql/9.1/main/postgresql.conf
```

and change the line:

```
#listen_addresses = 'localhost'
```

to

```
listen_addresses = '*'
```

(don’t forget to remove the “#” in front). Save and overwrite the file. To apply the changes, restart the database server:

```
sudo /etc/init.d/postgresql restart
```

To test if everything has been installed properly, log into the database as the new user we created.

```
psql gis gisuser
```

If you type \d you should be able to see all 3 tables. Then type \q to return.

**MAPNIK:**

Followed this: https://github.com/mapnik/mapnik/wiki/UbuntuInstallation

**TILE STACHE**

The first step in installing TileStache is to install mod_python which is the interface TileStache will use to communicate with the web server. You can install it with:

```
sudo apt-get install libapache2-mod-python
```

Then restart your web server with:

```
sudo /etc/init.d/apache2 restart
```

install some more packages that TileStache depends on.
First we’ll switch to the directory where we’ll keep the new applications:

```
cd /etc
```

Install packages Curl and Git via aptitude to help with the install:

```
sudo apt-get install curl
sudo apt-get install git-core
```

Now install some python tools and libraries that are required:

```
sudo apt-get install python-setuptools
sudo aptitude install python-dev
sudo apt-get install libjpeg8 libjpeg62-dev libfreetype6 libfreetype6-dev
```

We’ll grab and install PIP to easily install python modules:
[NOTE: I had to SUDO the curl command (because we're still in /etc]

```
curl -O https://raw.github.com/pypa/pip/master/contrib/get-pip.py
sudo python get-pip.py
```

Now install the required python modules

```
sudo pip install -U werkzeug
sudo pip install -U simplejson
sudo pip install -U modestmaps
```

The Python Image Library module has some quirks in Ubuntu 11.10 so we need to do some quick fixes:

```
sudo ln -s /usr/lib/x86_64-linux-gnu/libjpeg.so /usr/lib
sudo ln -s /usr/lib/x86_64-linux-gnu/libfreetype.so /usr/lib
sudo ln -s /usr/lib/x86_64-linux-gnu/libz.so /usr/lib
```

Before we can install it:

```
sudo pip install -U pil
```

Finally we’ll download TileStache from GitHub:
[NOTE: ALSO HAD TO sudo THIS]

```
git clone https://github.com/migurski/TileStache.git
```

And install it globally by running the install script:

```
cd TileStache/
python setup.py install
```

Finally, we’ll have to add the mod_python configuration to tell our web server which URLs to have TileStache process. Start by editing the apache configuration file:

```
sudo nano /etc/apache2/httpd.conf
```

and add this:

```
<Directory /var/www/tiles>
  AddHandler mod_python .py
  PythonHandler TileStache::modpythonHandler
  PythonOption config /etc/TileStache/tilestache.cfg
</Directory>
```

This will direct any web traffic to the “tiles” folder containing the file extension “.py” to TileStache. We just need to add a tiles directory to the web directory so we don’t get an error:

```
mkdir /var/www/tiles
```

**TESTING LOCALLY**

Go to web browser:

```
cd /etc/TileStache
./scripts/tilestache-server.py
## sudo /etc/init.d/apache2 restart ## if necessary
http://127.0.0.1:8080/example/preview.html
```
Another working example

```
cd /etc/TileStache/examples/zoom_example
tilestache-server.py -c zoom_example.cfg -i 127.0.0.1 -p 7890
```

then fire up

```
http://localhost:7890/composite/9/154/190.png
http://localhost:7890/composite/10/308/380.png
```
some explanation here: https://github.com/migurski/TileStache/blob/master/examples/zoom_example/test.html

### Next...
1. Learn more about Mapnik (before tilestache)
2. see https://github.com/mapnik/Ruby-Mapnik
3. couldn't build- anyway, Mapnik is about rendering (style) and NOT tiling