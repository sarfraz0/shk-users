#!/usr/bin/env python
# -*- coding: utf-8 -*-

__author__  = 'Sarfraz Kapasi'
__license__ = 'GPL-3'

# standard
import os
import json
import logging
import uuid
# custom
from shk.common.utils import init_logger
from shk.web.budget.frt.routes import app

# Globals
# =============================================================================

logger = logging.getLogger(__name__)

# Main
# =============================================================================

def main():
    cnf = {}
    with open(os.path.abspath('../etc/config.json')) as f:
        cnf = json.load(f)

    app.config['WTF_CSRF_ENABLED'] = True
    app.config['APP_NAME'] = cnf['app_name'] if 'app_name' in cnf else "Budget"
    app.config['SECRET_KEY'] = cnf['secret_key'] if 'secret_key' in cnf \
                                                 else str(uuid.uuid4())

    dev = (('develop' in cnf) and cnf['develop'])
    lgf = cnf['logfile'] if 'logfile' in cnf \
                         else os.path.abspath('../var/log/budget_wsgi.out')
    if dev:
        logger = init_logger(lgf, logging.DEBUG)
    else:
        logger = init_logger(lgf, logging.INFO)

    logger.info('Log filepath=%s', lgf)

    app.run()

if __name__ == '__main__':
    main()

#
