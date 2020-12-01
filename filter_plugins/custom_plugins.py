# depem: Strip PEM headers and remove all whitespace from string
# Usage: {{ foo | depem }}

def depem(string):
  import re
  return re.sub(r'\s+|(-----(BEGIN|END).*-----)', '', string)

class FilterModule(object):
  def filters(self):
    return {
      'depem': depem,
    }
