# Returns the number of subshells deep we are.
#
# For some reason, in my shell, $SHLVL is 2 initially, so this function adjusts
# for that and treats my initial nesting level as 0.
function nesting_level
  math -- "$SHLVL - 2"
end

function taskwarrior_task_count
  which task >/dev/null; or return
  set -l tasks_ready (task ready 2>/dev/null | grep -E '[0-9]+ tasks?')
  test $status -eq 0; or return
  printf ' (%s ready)' $tasks_ready
end

function fish_prompt
  set -l last_command_status $status
  if test $last_command_status -ne 0
    set_color --bold red
    echo "Exit code: $last_command_status"
    set_color normal
  end

  echo

  if test (nesting_level) -gt 0
    printf "%d) " (nesting_level)
  end

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
