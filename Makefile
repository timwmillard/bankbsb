EXTENSION = bankbsb        # the extensions name
DATA = bankbsb--0.0.1.sql  # script files to install
REGRESS = bankbsb	       # our test script file (without extension)
MODULES = bankbsb          # our c module file to build

# postgres build stuff
PG_CONFIG = pg_config
PGXS := $(shell $(PG_CONFIG) --pgxs)
include $(PGXS)
