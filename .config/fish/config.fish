starship init fish | source
set -U fish_greeting
fastfetch

# n8n Exclude Node
set -gx NODES_EXCLUDE "[]"
set -x N8N_BLOCK_FILE_ACCESS_TO_N8N_FILES false
set -gx N8N_RESTRICT_FILE_ACCESS_TO /home/kimsora/git/research

# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH
