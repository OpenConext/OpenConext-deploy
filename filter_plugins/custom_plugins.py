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
  import sys
  (out, err) = subprocess.Popen(['python', '-c', method], stdout=subprocess.PIPE).communicate()
  if (err != None):
    sys.exit("Unable to decrypt, error: {error}".format(error = err))
  else:
    return out
class FilterModule(object):

  def filters(self):
    return {
      'vault': vault
    }
