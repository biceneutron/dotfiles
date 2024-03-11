local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {}) -- project file: search in the whole project
vim.keymap.set('n', '<leader>fb', builtin.buffers, {}) -- project file: search in the whole project
vim.keymap.set('n', '<C-p>', builtin.git_files, {}) -- git project fuzzy search
vim.keymap.set('n', '<leader>sp', function()
	builtin.grep_string({ search = vim.fn.input("Grep > ") })
 end) -- project search 
