function taskwarrior_task_count
  which task >/dev/null; or return
  which re-matches >/dev/null; or return
  set -l tasks_ready (task ready 2>/dev/null | re-matches '(\d+ tasks?)')
  test $status -eq 0; or return
  printf ' (%s ready)' $tasks_ready
end

function fish_prompt
  echo

  set -l mode_color

  switch $fish_bind_mode
    case default # normal mode
      set mode_color green
    case visual
      set mode_color cyan
    case '*' # insert mode or anything else
      set mode_color yellow
  end

  set_color --bold $mode_color
  echo -n (prompt_segments | tail -n1)

  set_color normal # undoes --bold
  set_color --dim white
  taskwarrior_task_count
  set_color normal # undoes the --dim

  set_color --bold $mode_color
  printf ' → '

  set_color normal
end
