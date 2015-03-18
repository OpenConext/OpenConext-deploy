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
  import subprocess
  child = subprocess.Popen(['python', '-c', method], stdout=subprocess.PIPE)
  output = child.communicate()[0]
  if child.returncode != 0:
    raise ValueError("Exit code non-zero: %d" % child.returncode)
  return output

class FilterModule(object):

  def filters(self):
    return {
      'vault': vault
    }
