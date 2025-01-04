{
  lib,
  pinentry-curses,
  writeShellScript,
}:
writeShellScript "curses-ssh-askpass" ''
  if [ -z ''${1+x} ]; then
    prompt="GETPIN"
  else
    prompt="SETDESC $1\nGETPIN"
  fi

  pin=$(echo -e "$prompt" | ${lib.getExe pinentry-curses} -T /dev/pts/0 | grep D | tr -d '\n')
  echo "''${pin:2}"
''
