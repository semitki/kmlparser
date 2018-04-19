import os
from sqlalchemy import create_engine

def build_url (path, scheme='http'):
    return scheme + '://' + path

def engine():
    echo = False
    if 'PYTHON_ENV' in os.environ and os.environ['PYTHON_ENV'] == 'development':
        echo=True
    return create_engine(os.environ['KML_DBURL'],
		 echo=echo)

def kml2py(doc):
    script = write_python_script_for_kml_document(doc)
    output = open(outfile, 'w')
    output.write(script)
    output.close()


