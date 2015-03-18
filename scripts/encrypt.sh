#!/usr/bin/env python
import os.path
import getpass
from optparse import OptionParser
from keyczar import keyczar

parser = OptionParser()
parser.add_option("-d", "--decrypt", action="store_true", help="decrypt the input", dest="decrypt")
parser.add_option("-e", "--environment", action="store", type="string", help="target environment", dest="env", default="vm")

(options, args) = parser.parse_args()

keydir = os.path.expanduser('~/.decrypted_openconext_keystore_' + options.env)
crypter = keyczar.Crypter.Read(keydir)

if options.decrypt:
  encrypted_input = raw_input("Type the encrypted string: ")
  print 'The decrypted secret: %s' % crypter.Decrypt(encrypted_input)
else:
  password = getpass.getpass('Type the secret you want to encrypt: ')
  encrypted_secret = crypter.Encrypt(password)
  print 'The encrypted secret: %s' % encrypted_secret
