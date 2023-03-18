echo "################
# ZSH PLUGGINS #
################"
echo "installing zsh plugins"
# 1. SYNTAX HIGHLIGHTING
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# 2. Autosuggestions
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions


echo "##############
# Fonts-Powerline #
##############\n"
# TODO Fix this part
echo "installing fonts-powerline"
sudo apt-get install fonts-powerline
# git clone --filter=blob:none --sparse git@github.com:ryanoasis/nerd-fonts
# cd nerd-fonts
# git sparse-checkout add patched-fonts/JetBrainsMono
# sudo ./install.sh JetBrainsMono


echo "###############
# p10k themes #
###############\n"
echo "install p10k"
git clone --depth=1 https://github.com/romkatv/powerlevel10k $ZSH_CUSTOM/themes/powerlevel10k


echo "###########
# Colorls #
###########\n"
echo "installing colorls"
sudo apt install ruby-full

gem install colorls

echo "##########
# NEOVIM #
##########\n"
echo "installing and configuring neovim"
sudo apt-get install neovim

# create nvim config directory if it's not installed
if ! [[ -d "~/.config/nvim" ]];
then 
    mkdir ~/.config/nvim
fi

# My pluggin configurations from github
git clone https://github.com/jkanangila/configurations-scripts.git ~/.config/nvim

# vim-plug
curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim


echo "add: 'zsh-syntax-highlighting' to pluggin list"
echo "add: 'zsh-autosuggestions' to pluggin list"
echo "set ZSH_THEME='powerlevel10k/powerlevel10k'"
