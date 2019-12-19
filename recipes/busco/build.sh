#!/bin/bash

python setup.py install

mkdir -p $PREFIX/bin/
cp bin/busco $PREFIX/bin/busco #python script
cp scripts/generate_plot.py $PREFIX/bin/generate_plot.py
cp scripts/busco_configurator.py $PREFIX/bin/busco_configurator.py



#create config file



# BUSCO needs a config file with paths to external dependencies. These deps are
# installed as runtime deps, but the paths in the config file need to reflect
# the current environment's $PREFIX/bin dir. BUSCO expects a config file in
# ../config/config.ini, so we create it here using busco_configurator.py on the default ini
# stored in the share dir, replacing paths as necessary.

SHARE=$PREFIX/share/$PKG_NAME-$PKG_VERSION-$PKG_BUILDNUM
mkdir -p $SHARE
cp config/config.ini.default $SHARE/config.ini.default
mkdir -p "$PREFIX/config"
busco_configurator.py "$SHARE/config.ini.default" "$PREFIX/config/config.ini"

# This should not be necessary in v4.0.1
mkdir -p ${PREFIX}/etc/conda/activate.d ${PREFIX}/etc/conda/deactivate.d
cat 'export BUSCO_CONFIG_FILE="$PREFIX/config/config.ini"' > ${PREFIX}/etc/conda/activate.d/set_busco_variable.sh
cat "unset BUSCO_CONFIG_FILE" > ${PREFIX}/etc/conda/deactivate.d/set_busco_variable.sh
