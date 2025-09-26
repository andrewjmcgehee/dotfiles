def time_delta:
  now - (. | fromdateiso8601) | floor as $secs |
  ($secs / 60) | floor as $mins |
  ($secs / 3600) | floor as $hours |
  ($secs / 86400) | floor as $days |
  if $days >= 90 then
    "stale"
  elif $days >= 1 then
    ($days | tostring) + "d ago"
  elif $hours >= 1 then
    ($hours | tostring) + "h ago"
  elif $mins >= 1 then
    ($mins | tostring) + "m ago"
  else
    ($secs | tostring) + "s ago"
  end;

def ascii_only:
  [explode[] | select(. < 128)] | implode;

def rpad(size):
  . | tostring |
  if (. | length) >= size then
    .[:size]
  else
    . + (" " * (size - (. | length)))
  end;

def lpad(size):
  . | tostring |
  if (. | length) >= size then
    .[:size]
  else
    (" " * (size - (. | length))) + .
  end;

def ascii_rpad(size):
  . | tostring | ascii_only |
  if (. | length) >= size then
    .[:size]
  else
    . + (" " * (size - (. | length)))
  end;

def ascii_lpad(size):
  . | tostring | ascii_only |
  if (. | length) >= size then
    .[:size]
  else
    (" " * (size - (. | length))) + .
  end;

def read_status:
  if .unread then
    "◉"
  else
    ""
  end;

def notification_type:
  if .subject.type == "PullRequest" then
    "PR"
  elif .subject.type == "Issue" then
    "ISS"
  elif .subject.type == "Release" then
    "REL"
  else
    .subject.type
  end;
