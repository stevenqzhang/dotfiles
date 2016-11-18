# dotfiles
mostly just my bashrc file

# Setup
Add this line into ~\.bashrc

```
git clone https://github.com/stevenqzhang/dotfiles.git ~/dev/dotfiles 
LINE='source ~/dev/dotfiles/.bashrc'
FILE=~/.bashrc
grep -q "$LINE" "$FILE" || echo "$LINE" >> "$FILE"
LINE='source ~/.bashrc'
FILE=~/.bash_profile
grep -q "$LINE" "$FILE" || echo "$LINE" >> "$FILE"
LINE='source ~/dev/dotfiles/.vimrc'
FILE=~/.vimrc
grep -q "$LINE" "$FILE" || echo "$LINE" >> "$FILE"
```

OR, run copy the one liner from this gist to wget it all at once: 
https://gist.github.com/stevenqzhang/ba2af7a3cd2be5651d1b
