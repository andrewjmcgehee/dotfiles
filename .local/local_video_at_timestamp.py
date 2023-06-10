import os
import pathlib
import sys

HOME = "/Users/amcg"
DISK = "Macintosh HD"
OSA_SCRIPT_PATH = "/Users/amcg/.local/bin/local_video_at_timestamp.scpt"


def main():
  args = sys.argv
  if len(args) < 2:
    print("no args passed to local video at timestamp script")
    return 1
  raw = args[1]
  raw = raw.strip("*_`[]{}()$=~>;:-")
  f, t = raw.split(" @ ")
  h, m, s = map(int, t.split(":"))
  f = os.popen(f"find -E ~/Workspaces -regex '.*{f}'").read().strip()
  filepath = str(pathlib.Path(f).resolve())
  filepath = DISK + filepath.replace("/", ":")
  time = 3600*h + 60*m + s
  os.system(f"osascript {OSA_SCRIPT_PATH} '{filepath}' {time}")
  return 0


if __name__ == "__main__":
  main()
