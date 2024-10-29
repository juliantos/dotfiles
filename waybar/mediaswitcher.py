#!/usr/bin/env python3
import argparse
import logging
import gi
import sys
gi.require_version('Playerctl', '2.0')
from gi.repository import Playerctl
from i3ipc import Connection, Event

logger = logging.getLogger(__name__)

sway = Connection()

def parse_arguments():
    parser = argparse.ArgumentParser()

    parser.add_argument('-v', '--verbose', action='count', default=0)

    parser.add_argument('--player')

    return parser.parse_args()

def main():
    arguments = parse_arguments()

    logging.basicConfig(stream=sys.stderr, level=logging.DEBUG,
                        format='%(name)s %(levelname)s %(message)s')
    logger.setLevel(max((3 - arguments.verbose) * 10, 0))
    logger.debug('Arguments received {}'.format(vars(arguments)))

    found_player = None
    for player in filter(lambda p: p.name.lower() == arguments.player.lower(), Playerctl.list_players()):
        found_player = Playerctl.Player.new(player.instance)
    logger.debug('Found Player {} [{}]'.format(arguments.player, found_player))

    if found_player != None:
        workspaces = sway.get_workspaces()
        for workspace in filter(lambda w: not w.focused, workspaces):
            if found_player.props.player_name in workspace.ipc_data['representation'].lower():
                sway.command('workspace {}'.format(workspace.num)) 

    
if __name__ == '__main__':
    main()

