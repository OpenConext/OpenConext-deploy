#
# Usage: {{ foo | vault }}
#
def vault(encrypted):
  method = """
from keyczar import keyczar
import os.path
import sys
keydir = '.vault'
if not os.path.isdir(keydir):
  keydir = os.path.expanduser('~/.decrypted_openconext_keystore')
crypter = keyczar.Crypter.Read(keydir)
sys.stdout.write(crypter.Decrypt("%s"))
  """ % encrypted
  import subprocess
  return subprocess.Popen(['python', '-c', method], stdout=subprocess.PIPE).communicate()[0]

class FilterModule(object):

  def filters(self):
    return {
      'vault': vault
    }
