#!/usr/bin/env python3

import json
import os
from pathlib import Path
import shutil
from zipfile import ZipFile


from argparse import ArgumentParser
parser = ArgumentParser()
parser.add_argument('command', choices=['build', 'install'])
args = parser.parse_args()


steps = {
    'build': ['build'],
    'install': ['build', 'install'],
}[args.command]


game_dir = Path(os.environ['HOME'], 'factorio')
mods_dir = game_dir / 'mods'
mod_dir = Path(__file__).parent
src_dir = mod_dir / 'src'

with open(src_dir / 'info.json') as f:
    info_json = json.load(f)

mod_name = info_json['name']
mod_version = info_json['version']

artifact_dir = mod_dir / 'artifacts'
artifact_dir.mkdir(exist_ok=True)
artifact_path = artifact_dir / f'{mod_name}_{mod_version}.zip'


def step_build():
    with ZipFile(artifact_path, 'w') as zf:
        for root, dirs, files in os.walk(src_dir):
            for file in files:
                real_path = Path(root, file)
                zip_path = Path(
                    f'{mod_name}_{mod_version}',
                    real_path.relative_to('src'),
                )
                print(f'{real_path} -> {artifact_path / zip_path}')
                zf.write(real_path, zip_path)

def step_install():
    print(f'{artifact_path} -> {mods_dir}')
    shutil.copy(artifact_path, mods_dir)
    print('enabling mod')
    mod_list_path = mods_dir / 'mod-list.json'
    with open(mod_list_path) as f:
        mod_list = json.load(f)
    mods = {
        mod['name']: mod['enabled']
        for mod in mod_list['mods']
        if mod['name'] != 'base'
    }
    mods[mod_name] = True
    mod_list = {
        'mods': [
            {
                'name': name,
                'enabled': enabled,
            }
            for name, enabled in sorted(mods.items())
        ],
    }
    mod_list['mods'].insert(
        0,
        {
            'name': 'base',
            'enabled': True,
        },
    )
    with open(mod_list_path, 'w') as f:
        json.dump(mod_list, f, indent=2)

for step in steps:
    print(step)
    globals()[f'step_{step}']()
