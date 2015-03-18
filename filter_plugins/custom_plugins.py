#
# Usage: {{ foo | vault }}
#

def vault(encrypted, env):
  method = """
from keyczar import keyczar
import os.path
import sys
keydir = '.vault'
if not os.path.isdir(keydir):
  keydir = os.path.expanduser('~/.decrypted_openconext_keystore_{env}')
crypter = keyczar.Crypter.Read(keydir)
sys.stdout.write(crypter.Decrypt("%s"))
  """.format(env=env) % encrypted
  from subprocess import check_output
  return check_output(["python", "-c", method])

class FilterModule(object):

  def filters(self):
    return {
      'vault': vault
    }
