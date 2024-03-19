if status is-interactive
	abbr -a -- vi 'nvim'
	abbr -a -- vv 'source ./.venv/bin/activate.fish'
	abbr -a -- vd 'deactivate'
	abbr -a -- lx 'exa'
	abbr -a -- lxtree 'exa --git-ignore --tree '
end

function fish_right_prompt
	echo (date '+%b %d %H:%M:%S')' '
end

function fish_mode_prompt
	switch $fish_bind_mode
	case default
		set_color --bold '888888'
		echo '[N] '
	case insert
		set_color --bold '40E0D0'
		echo '[I] '
	case replace_one
		set_color --bold green
		echo '[r] '
	case replace
		set_color --bold green
		echo '[R] '
	case visual
		set_color --bold brmagenta
		echo '[V] '
	case '*'
		set_color --bold red
		echo '??? '
	end
	set_color normal
end

function fish_prompt -d "Write out the prompt"
	printf '%s%s%s\n> ' (set_color --bold yellow) (prompt_pwd) (set_color normal)
end

