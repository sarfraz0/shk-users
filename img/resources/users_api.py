#!/usr/bin/env python
# -*- coding: utf-8 -*-

__author__  = 'Sarfraz Kapasi'
__license__ = 'GPL-3'

# standard
import os
import json
import logging
import argparse
# custom
from net.shksystem.common.utils import init_logger
from net.shksystem.web.users.api import run_api

# Globals
# =============================================================================

logger = logging.getLogger(__name__)

# Main
# =============================================================================

def main():
    ## arguments
    parser = argparse.ArgumentParser(description='users api executable')

    parser.add_argument(
              '-p',
              '--port',
              help='port to listen on',
              type=int,
              default=8080
           )
    parser.add_argument(
              '-l',
              '--logfile',
              help='path to log file',
              default='users.out'
           )
    parser.add_argument(
              '-v',
              '--verbosity',
              help='DEBUG switch',
              action='store_true'
           )
    parser.add_argument(
              '-d',
              '--db-url',
              help='database url',
              default='sqlite:///users.db'
           )
    parser.add_argument(
              '-b',
              '--postgres-backend',
              help='postgresql backend to use',
              default='psycopg2cffi'
           )
    args = parser.parse_args()


    ## logging
    if args.verbosity:
        logger = init_logger(args.logfile, logging.DEBUG)
    else:
        logger = init_logger(args.logfile, logging.ERROR)

    database_url = args.db_url
    if database_url.startswith('postgresql'):
        database_url = database_url.replace('postgresql',
                'postgresql+{0}'.format(args.postgres_backend,))

    run_api(database_url, port=args.port, debug=args.verbosity)

if __name__ == '__main__':
    main()

#
