#!/usr/bin/env python
import os.path
from optparse import OptionParser
from keyczar import keyczar

parser = OptionParser()
parser.add_option("-f", "--file", help="the input file", dest="filename", metavar="FILE")
parser.add_option("-d", "--decrypt", action="store_true", help="decrypt the file", dest="decrypt")

(options, args) = parser.parse_args()

if options.filename:
  with open(options.filename, 'r') as content_file:
    content = content_file.read()
    keydir = '.vault'
    if not os.path.isdir(keydir):
      keydir = os.path.expanduser('~/.openconext-keystore')
    crypter = keyczar.Crypter.Read(keydir)
    if options.decrypt:
      print crypter.Decrypt(content)
    else:
      encrypted_secret = crypter.Encrypt(content)
      print encrypted_secret
else:
  parser.print_help()

