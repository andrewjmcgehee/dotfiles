local color = require("ansicolors")
local logging = require("logging")
require("logging.file")

-- set up the default logger to stderr + colorization
logging.defaultLogger(logging.file {
  logLevel = logging.DEBUG,
  filename = "/tmp/lualogging.log",
  timestampPattern = "%Y-%m-%d %H%M%S%q",
  logPatterns = {
    [logging.DEBUG] = color("%{magenta}[%level]%{reset} %date %message (%source)\n"),
    [logging.INFO] = color("%{green}[%level]%{reset} %date %message\n"),
    [logging.WARN] = color("%{yellow}[%level]%{reset} %date %message\n"),
    [logging.ERROR] = color("%{red}[%level] %date %message%{reset} (%source)\n"),
    [logging.FATAL] = color("%{red}[%level] %date %message%{reset} (%source)\n"),
  }
})

LOG = logging.defaultLogger()

