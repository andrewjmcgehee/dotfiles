local fn = vim.fn

local jdtls = require("jdtls")
local get_data_path = function()
	local java_workspace = vim.env.HOME .. "/Workspaces/java/"
	local root_dir = require("jdtls.setup").find_root({ ".git", "mvnw", "gradlew" })
	if not root_dir then
		local cwd = fn.fnamemodify(fn.getcwd(), ":p:h:t")
		if fn.isdirectory(java_workspace .. cwd) == 1 then
			root_dir = cwd
		else
			local proceed = fn.input("Start new java project? [y/n]: ")
			proceed = (proceed == "y")
			if proceed then
				root_dir = cwd
			end
		end
	end
	root_dir = root_dir or "default"
	return java_workspace .. root_dir
end

local jdtls_path = fn.stdpath("data") .. "/mason/packages/jdtls/"
local launcher_version = "1.6.400.v20210924-0641"
local os_name = "mac"
local capabilities = require("cmp_nvim_lsp").default_capabilities()

local config = {
	cmd = {
		"java",
		"-Declipse.application=org.eclipse.jdt.ls.core.id1",
		"-Dosgi.bundles.defaultStartLevel=4",
		"-Declipse.product=org.eclipse.jdt.ls.core.product",
		"-Dlog.protocol=true",
		"-Dlog.level=ALL",
		"-Xms1g",
		"--add-modules=ALL-SYSTEM",
		"--add-opens",
		"java.base/java.util=ALL-UNNAMED",
		"--add-opens",
		"java.base/java.lang=ALL-UNNAMED",
		"-jar",
		jdtls_path .. "plugins/org.eclipse.equinox.launcher_" .. launcher_version .. ".jar",
		"-configuration",
		jdtls_path .. "config_" .. os_name,
		"-data",
		get_data_path(),
	},
	capabilities = capabilities,
}
jdtls.start_or_attach(config)
