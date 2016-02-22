#!/usr/bin/env python
# -*- coding: utf-8 -*-

__author__  = 'Sarfraz Kapasi'
__license__ = 'GPL-3'

# standard
import os
import json
import logging
# custom
from net.shksystem.common.utils import init_logger
from net.shksystem.web.users.api import run_api

# Globals
# =============================================================================

logger = logging.getLogger(__name__)

# Main
# =============================================================================

def main():
    cnf = {}
    with open(os.path.abspath('../etc/config.json')) as f:
        cnf = json.load(f)

    dev = ('loglvl' in cnf and cnf['loglvl'] == 'dev')
    dbg = ('loglvl' in cnf and cnf['loglvl'] == 'dbg')
    lgf = cnf['logfile'] if 'logfile' in cnf \
                         else os.path.abspath('../var/log/budget_api.out')

    if 'loglvl' in cnf:
        levl = cnf['loglvl']
        if levl == 'dbg':
            logger = init_logger(lgf, logging.DEBUG)
        elif levl == 'dev':
            logger = init_logger(lgf, logging.INFO)
        elif levl == 'prd':
            logger = init_logger(lgf, logging.ERROR)

    database_url = os.environ['BUDGET_DATABASE_URI']

    if database_url.startswith('postgresql'):
        pback = 'psycopg2'
        if 'postgres_back' in cnf:
            pback = cnf['postgres_back']

        database_url = database_url.replace(
                                       'postgresql',
                                       'postgresql+{0}'.format(pback,))

    if ('app_port' in cnf):
        if dbg:
            run_api(database_url, port=cnf['app_port'], debug=True)
        else:
            run_api(database_url, port=cnf['app_port'])
    else:
        if dbg:
            run_api(database_url, debug=True)
        else:
            run_api(database_url)

if __name__ == '__main__':
    main()

#
