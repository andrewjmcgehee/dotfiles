local M = {}

function M.servers()
  return {
    dockerls = {},
    docker_compose_language_service = {},
  }
end

function M.setup()
  return {}
end

return M
