import os
import sys

_HOME = '/Users/amcg'
_WORKSPACES = 'Workspaces/'


def main():
  current_path = os.getcwd()
  if current_path.startswith(os.path.join(_HOME, _WORKSPACES)):
    workspaces_index = current_path.find(_WORKSPACES)
    if workspaces_index != -1:
      start = len(os.path.join(_HOME, _WORKSPACES))
      return '@' + current_path[start:]
  return current_path.replace(_HOME, '~')


if __name__ == '__main__':
  print(main())
