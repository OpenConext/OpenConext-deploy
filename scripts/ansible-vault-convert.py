#!/usr/bin/env python3

## converts a fully-encrypted ansible vault to per-varaiable encryption
## Adapted from https://gist.github.com/filipenf/2cc72af47e3570afaa9d3bf2e71658c3

import sys
import yaml
import argparse
from glob import glob
from pathlib import Path
from pprint import pprint


def _add_ansible_to_python_path() -> None:
    # find python version
    python_version = f"{sys.version_info.major}.{sys.version_info.minor}"

    # search a predefined list of paths for python site-packages dit, and if found, add them to the sys.path
    # this is necessary because the ansible python module is not in the default python path
    # this is the list of paths to search; note that paths may contain shell expansions,
    # which will be expanded in the search below
    search_paths = [
        f'/usr/local/lib/python{python_version}',
        f'/opt/homebrew/Cellar/ansible/*/libexec/lib/python{python_version}/'
    ]

    # now iterate over all search paths, expand any possible globs,
    # check if they contain a site-packages directory, and if so,
    # add it to the python path
    for path_glob in search_paths:
        #print(f"checking {path_glob}")
        for p in glob(path_glob, root_dir='/'):
            #print(f"checking {p}")
            path = Path(p)
            if not path.is_dir():
                continue
            if not (path / 'site-packages').is_dir():
                continue
            sys.path.append(str(path / 'site-packages'))


_add_ansible_to_python_path()
from ansible.parsing.vault import VaultLib
from ansible.cli import CLI
from ansible import constants as C
from ansible.parsing.dataloader import DataLoader
from ansible.parsing.yaml.dumper import AnsibleDumper
from ansible.parsing.yaml.loader import AnsibleLoader
from ansible.parsing.yaml.objects import AnsibleVaultEncryptedUnicode


class VaultHelper():
    def __init__(self, vault_id):
        loader = DataLoader()
        vaults = [v for v in C.DEFAULT_VAULT_IDENTITY_LIST if v.startswith('{0}@'.format(vault_id))]
        if len(vaults) != 1:
            raise ValueError("'{0}' does not exist in ansible.cfg '{1}'".format(vault_id, C.DEFAULT_VAULT_IDENTITY_LIST))

        self.vault_id = vault_id
        vault_secret = CLI.setup_vault_secrets(
            loader=loader,
            vault_ids=vaults
        )
        self.vault = VaultLib(vault_secret)

    def convert_vault_to_strings(self, vault_data):
        decrypted = self.vault.decrypt(vault_data)
        d = yaml.load(decrypted, Loader=AnsibleLoader)
        pprint(d, sort_dicts=False)
        self._encrypt_dict(d)
        return d

    def _encrypt_string(self, value: str):
        return AnsibleVaultEncryptedUnicode(
            self.vault.encrypt(plaintext=value, vault_id=self.vault_id)
        )

    def _encrypt_dict(self, d, vault_id=None):
        for key in d:
            value = d[key]
            if isinstance(value, str):
                d[key] = self._encrypt_string(value)
            elif isinstance(value, list):
                encrypted_list = []
                for item in value:
                    encrypted_list.append(self._encrypt_string(item))
                d[key] = encrypted_list
            elif isinstance(value, dict):
                self._encrypt_dict(value)
        return d



def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--input-file',
                        help='File to read from',
                        required=True)
    parser.add_argument('--output-file',
                        help='File to read from',
                        required=True)
    parser.add_argument('--vault-id',
                        help='Vault id used for the encryption',
                        required=True)
    args = parser.parse_args()
    original_secrets = open(args.input_file).read()
    vault = VaultHelper(args.vault_id)
    converted_secrets = vault.convert_vault_to_strings(original_secrets)

    pprint(converted_secrets, sort_dicts=False)
    with open(args.output_file, 'w+') as f:
        yaml.dump(converted_secrets, Dumper=AnsibleDumper, stream=f, sort_keys=False)


if __name__ == "__main__":
    main()
