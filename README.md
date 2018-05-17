# kmlparse


#### Requires Python 2 (Python 3 support on the way)

### Settings

Requires some environment variables, `PYTHON_ENV` enables verbose
output, `KML_BOOTSTRAP` if present will create the table in the data
base; `KML_DATA` directory where `.kml` files are read from.


    export KML_DATA=</some/path>
    export KML_DBURL=postgres://<mydb>
    export KML_BOOTSTRAP=1
    export PYTHON_ENV=development


### Install dependencies


    virtualenv -p python2.7 ENV
    . ENV/bin/activate
    pip install -r requirements.txt


### Import kml into PostgreSQL


    python <blocks|sections>kml.py <Source.kml>


A lot of kmls?


    for n in $(seq 1 <N>); do
      python <blocks|sections>kml.py <Source.kml>$n.kml
    done



### SQL Queries


    psql < sql/json2sf.sql
    psql < sql/coveredby.sql


Update relationship between manzanas and sections


    select update_seccion_manzanas(m.id, 1573)
      from (select id from manzanas_geojson) as m;


Faster variation?


    select update_seccion_manzanas(m.id, 1573)
      from (select id,seccion from manzanas_geojson) as m
      where m.seccion is null;



