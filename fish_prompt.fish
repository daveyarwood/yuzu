function fish_prompt
	echo

  switch $fish_bind_mode
    case default # normal mode
      set_color --bold green
    case visual
      set_color --bold cyan
  case '*' # insert mode or anything else
    set_color --bold yellow
  end

  printf '%s → ' (prompt_segments | tail -n1)

  set_color normal
end
