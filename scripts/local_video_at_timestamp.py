import os
import pathlib
import sys

DISK = "Macintosh HD"
OSA_SCRIPT = "local_video_at_timestamp.scpt"


def main():
  args = sys.argv
  if len(args) < 2:
    print("no args passed to local video at timestamp script")
    return
  raw = args[1]
  raw = raw.strip("*_`[]{}()$=~>;:-")
  f, t = raw.split(" @ ")
  h, m, s = map(int, t.split(":"))
  f = os.popen(f"find -E $HOME/Workspaces -regex '.*{f}'").read().strip()
  filepath = str(pathlib.Path(f).resolve())
  filepath = DISK + filepath.replace("/", ":")
  print(filepath)
  time = 3600 * h + 60 * m + s
  _ = os.system(f"osascript {OSA_SCRIPT} '{filepath}' {time}")


if __name__ == "__main__":
  main()
