local M = {}

function M.augroup(name)
	return vim.api.nvim_create_augroup("user_" .. name, { clear = true })
end

function M.get_hl(name)
	return vim.api.nvim_get_hl(0, { name = name, link = false })
end

local function blend_channel(from, to, alpha)
	return math.floor((from * (1 - alpha)) + (to * alpha) + 0.5)
end

function M.blend_colors(from, to, alpha)
	local from_r = math.floor(from / 0x10000) % 0x100
	local from_g = math.floor(from / 0x100) % 0x100
	local from_b = from % 0x100
	local to_r = math.floor(to / 0x10000) % 0x100
	local to_g = math.floor(to / 0x100) % 0x100
	local to_b = to % 0x100

	return (blend_channel(from_r, to_r, alpha) * 0x10000)
		+ (blend_channel(from_g, to_g, alpha) * 0x100)
		+ blend_channel(from_b, to_b, alpha)
end

return M
