local group = vim.api.nvim_create_augroup("lsp_roslyn_ls", { clear = true })

local function find_root(bufnr, predicate)
	local fname = vim.api.nvim_buf_get_name(bufnr)
	return vim.fs.root(fname, predicate)
end

local function open_solution(client, target)
	client:notify("solution/open", {
		solution = vim.uri_from_fname(target),
	})
end

local function open_projects(client, project_files)
	client:notify("project/open", {
		projects = vim.tbl_map(vim.uri_from_fname, project_files),
	})
end

local function refresh_diagnostics(client, bufnr)
	for _, capability in pairs(client.dynamic_capabilities.capabilities.diagnosticProvider or {}) do
		local identifier = capability.registerOptions.identifier
		if identifier ~= "DocumentCompilerSemantic" and identifier ~= "DocumentAnalyzerSemantic" then
			goto continue
		end
		client:request(vim.lsp.protocol.Methods.textDocument_diagnostic, {
			identifier = identifier,
			textDocument = vim.lsp.util.make_text_document_params(bufnr),
		}, nil, bufnr)
		::continue::
	end
end

local function handlers()
	return {
		["workspace/projectInitializationComplete"] = function(_, _, ctx)
			local client = vim.lsp.get_client_by_id(ctx.client_id)
			if client then
				for bufnr in pairs(client.attached_buffers) do
					if not vim.b[bufnr].roslyn_ls_initial_diagnostics then
						vim.b[bufnr].roslyn_ls_initial_diagnostics = true
						refresh_diagnostics(client, bufnr)
					end
				end
			end
			return vim.NIL
		end,
	}
end

---@type vim.lsp.Config
local roslyn_ls = vim.fn.exepath("roslyn-language-server")
if roslyn_ls == "" then
	roslyn_ls = vim.fn.expand("~/.dotnet/tools/roslyn-language-server")
end

return {
	name = "roslyn_ls",
	cmd = { roslyn_ls, "--stdio" },
	cmd_env = {
		DOTNET_ROOT = "/opt/homebrew/opt/dotnet/libexec",
		DOTNET_ROOT_ARM64 = "/opt/homebrew/opt/dotnet/libexec",
		TMPDIR = vim.env.TMPDIR and vim.env.TMPDIR ~= "" and vim.fn.resolve(vim.env.TMPDIR) or nil,
	},
	flags = {
		allow_incremental_sync = true,
	},
	filetypes = { "cs" },
	handlers = handlers(),
	root_dir = function(bufnr, on_dir)
		local root = find_root(bufnr, function(name)
			return name:match("%.slnx?$") ~= nil
		end) or find_root(bufnr, function(name)
			return name:match("%.csproj$") ~= nil
		end)

		if root then
			on_dir(root)
		end
	end,
	on_init = function(client)
		local root_dir = client.config.root_dir
		local projects = {}

		for entry, type in vim.fs.dir(root_dir) do
			if type == "file" and (vim.endswith(entry, ".sln") or vim.endswith(entry, ".slnx")) then
				open_solution(client, vim.fs.joinpath(root_dir, entry))
				return
			end
			if type == "file" and vim.endswith(entry, ".csproj") then
				table.insert(projects, vim.fs.joinpath(root_dir, entry))
			end
		end

		if #projects > 0 then
			open_projects(client, projects)
		end
	end,
	on_attach = function(client, bufnr)
		vim.api.nvim_create_autocmd({ "BufWritePost", "InsertLeave" }, {
			group = group,
			buffer = bufnr,
			callback = function()
				refresh_diagnostics(client, bufnr)
			end,
			desc = "roslyn_ls: refresh diagnostics",
		})
	end,
	capabilities = vim.tbl_deep_extend("force", vim.lsp.protocol.make_client_capabilities(), {
		textDocument = {
			diagnostic = {
				dynamicRegistration = true,
			},
		},
	}),
	settings = {
		["csharp|background_analysis"] = {
			dotnet_analyzer_diagnostics_scope = "openFiles",
			dotnet_compiler_diagnostics_scope = "openFiles",
		},
		["csharp|completion"] = {
			dotnet_show_completion_items_from_unimported_namespaces = true,
			dotnet_show_name_completion_suggestions = true,
		},
	},
}
