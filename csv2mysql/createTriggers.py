#!/usr/bin/python
# -*- coding: utf-8 -*-

import os
import re
import sys
import csv
import time
import argparse
import collections
import MySQLdb
import warnings
# suppress annoying mysql warnings
warnings.filterwarnings(action='ignore', category=MySQLdb.Warning)
