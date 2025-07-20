ZSH_THEME_VIRTUALENV_PREFIX="(%{$fg_bold[cyan]%}"   # avant le « ( »
ZSH_THEME_VIRTUALENV_SUFFIX="%{$reset_color%}) "
ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[white]%}(%{$fg_bold[blue]%}on: %{$fg_bold[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%f)"
ZSH_THEME_GIT_PROMPT_MODIFIED="test"
ZSH_THEME_GIT_PROMPT_DIRTY=""
# Choisis tes couleurs/formats :
ZSH_THEME_VIRTUALENV_PROMPT_PREFIX="%{$fg_bold[cyan]%}("   # avant le nom
ZSH_THEME_VIRTUALENV_PROMPT_SUFFIX=")%{$fg_bold[white]%} - " # après le nom

#git status
ZSH_THEME_GIT_PROMPT_ADDED="%{$fg[green]%} ✓"
ZSH_THEME_GIT_PROMPT_MODIFIED="%{$fg[yellow]%} ●"
ZSH_THEME_GIT_PROMPT_DELETED="%{$fg[red]%} ✘ "
ZSH_THEME_GIT_PROMPT_RENAMED="%{$fg[blue]%} ●"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg_bold[red]%} ●"
###############################################################################
# 1.  Fonction utilitaire : construit la chaîne PROMPT
###############################################################################
#  $1 : durée déjà formatée (ex. « 1m23s », « 0.127s », « 15ms »)
#  $2 : nom de la couleur (red | yellow | green | white…)
build_prompt () {
  local elapsed="$1"
  local color="$2"

  if [ "$UID" -eq 0 ]; then
    # partie avant/​après commune – on garde $(...) littéraux grâce aux quotes simples
    prompt_head='$(virtualenv_prompt_info)%Bon: %{$fg_bold[red]%}$USER@%m %{$fg_bold[white]%}- %2~ - time: '
  else
    prompt_head='$(virtualenv_prompt_info)%Bon: %{$fg_bold[yellow]%}$USER@%m %{$fg_bold[white]%}- %2~ - time: '
  fi
  prompt_tail='%{$fg_bold[white]%} - $(git_prompt_info) $(git_prompt_status) %{$fg[none]%}
%{$fg_bold[white]%}→%b '

  # on assemble la couleur et la durée entre les deux
  PROMPT="${prompt_head}%{$fg_bold[${color}]%}${elapsed}${prompt_tail}"
}

# prompt par défaut (premier affichage)
build_prompt '0ms' 'white'

###############################################################################
# 2.  Hooks pré‑exec / pré‑cmd : calcul de la durée + appel à build_prompt
###############################################################################
prompt_preexec() {
  prompt_prexec_realtime=${EPOCHREALTIME}
}

prompt_precmd() {
  if (( prompt_prexec_realtime )); then
    local -rF elapsed_realtime=$(( EPOCHREALTIME - prompt_prexec_realtime ))
    local -rF s=$(( elapsed_realtime % 60 ))
    local -ri elapsed_s=${elapsed_realtime}
    local -ri m=$(( (elapsed_s / 60) % 60 ))
    local -ri h=$(( elapsed_s / 3600 ))

    if   (( h > 0 ));        then printf -v prompt_elapsed_time '%ih%im' ${h} ${m}; build_prompt "$prompt_elapsed_time" 'red'
    elif (( m > 0 ));        then printf -v prompt_elapsed_time '%im%is' ${m} ${s}; build_prompt "$prompt_elapsed_time" 'red'
    elif (( s >= 10 ));      then printf -v prompt_elapsed_time '%.2fs' ${s}; build_prompt "$prompt_elapsed_time" 'red'
    elif (( s >= 1 ));       then printf -v prompt_elapsed_time '%.3fs' ${s}; build_prompt "$prompt_elapsed_time" 'yellow'
    else                          printf -v prompt_elapsed_time '%ims' $(( s * 1000 )); build_prompt "$prompt_elapsed_time" 'green'
    fi

    unset prompt_prexec_realtime
  else
    # touche Entrée sans commande → on enlève la durée précédente
    unset prompt_elapsed_time
    build_prompt '0ms' 'white'
  fi
}

###############################################################################
# 3.  Options & hooks (inchangés)
###############################################################################
setopt nopromptbang prompt{cr,percent,sp,subst}

autoload -Uz add-zsh-hook
add-zsh-hook preexec prompt_preexec
add-zsh-hook precmd  prompt_precmd

RPROMPT='%(?.%{$fg[green]%}✔%f.%{$fg[red]%}✘%f)'
