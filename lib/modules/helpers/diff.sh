#!/usr/bin/env bash

gf_helper_diff_menu_content() {
  # locals sorted by last commit
  GF_BRANCH_LOCAL_BRANCHES="$(git for-each-ref --sort='-committerdate' \
    --format="local $GREEN$BOLD%(refname:short)$NORMAL|$MAGENTA%(committerdate:relative)$NORMAL|$CYAN%(committername)$NORMAL" \
    refs/heads | \
    column -t -s'|' \
  )"

  echo "nothing ${CYAN}-- LOCAL --${NORMAL}"
  echo "nothing"

  if [ -n "$GF_BRANCH_LOCAL_BRANCHES" ]; then
    echo "$GF_BRANCH_LOCAL_BRANCHES"
  else
    echo "nothing ${RED}no local branches${NORMAL}"
  fi

  echo "nothing"
  echo "nothing ${CYAN}-- REMOTE --${NORMAL}"
  echo "nothing"

  # locals sorted by last commit
  GF_BRANCH_REMOTE_BRANCHES="$(git for-each-ref --sort='-committerdate' \
    --format="remote $YELLOW$BOLD%(refname:short)$NORMAL|$MAGENTA%(committerdate:relative)$NORMAL|$CYAN%(committername)$NORMAL" \
    refs/remotes | \
    column -t -s'|' \
  )"

  if [ -n "$GF_BRANCH_REMOTE_BRANCHES" ]; then
    echo "$GF_BRANCH_REMOTE_BRANCHES"
  else
    echo "nothing ${RED}no remote branches${NORMAL}"
  fi
}

gf_helper_diff_preview_content() {
  if [ -z "$1" ]; then
    gf_preview_shortcuts_header
    echo "nothing to show"
  elif [ "$1" = '.' ]; then
    gf_preview_shortcuts_header
    echo "nothing to show"
  else
    gf_preview_shortcuts_header_with_inspect

    REF="$1"
    # shellcheck disable=2086
    gf_git_command_with_header 1 diff $GF_DIFF_COMMIT_RANGE_PREVIEW_DEFAULTS "$(git merge-base "$GF_BASE_BRANCH" "$REF")" "$REF" | gf_diff_renderer
  fi
}

gf_helper_diff_inspect() {
  case "$1" in
    ''|'.'|'nothing')
      return
      ;;
  esac

  trap 'exit 0' INT

  REF="$1"
  # shellcheck disable=2086
  gf_git_command_with_header 1 diff $GF_DIFF_COMMIT_RANGE_PREVIEW_DEFAULTS "$(git merge-base "$GF_BASE_BRANCH" "$REF")" "$REF" |
    gf_helper_inspect_diff_renderer |
    gf_helper_inspect_pager
}

gf_helper_diff_select() {
  git fuzzy diff "$@"
}
