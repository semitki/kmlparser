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


Install dependencies


    virtualenv ENV
    . ENV/bin/activate
    pip install -r requirements.txt


### Import kml into PostgreSQL


    python kml.py <Source.kml>


### SQL Queries

