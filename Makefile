all: zsh psql git tmux brew

zsh:
	ln -sf ~/.dotfiles/.zshrc ~/.zshrc

psql:
	ln -sf ~/.dotfiles/.psqlrc ~/.psqlrc

git:
	ln -sf ~/.dotfiles/.gitignore ~/.gitignore
	ln -sf ~/.dotfiles/.gitconfig ~/.gitconfig

tmux:
	ln -sf ~/.dotfiles/.tmux.conf ~/.tmux.conf

brew:
	ln -sf ~/.dotfiles/Brewfile ~/Brewfile
	ln -sf ~/.dotfiles/Brewfile.lock.json ~/Brewfile.lock.json
