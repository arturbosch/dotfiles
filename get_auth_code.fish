#!/usr/bin/env fish

if not test -f /tmp/latest_mail.html
    notify-send "Auth Code" "No email file found"
    exit 1
end

set pi_cmd 'command pi --thinking off --no-extensions --no-tools --no-session --no-context-files --no-themes --no-skills -p "Extract and print only the authentication code from this email. Print nothing else."'
set code (cat /tmp/latest_mail.html | eval $pi_cmd)
set code (echo $code | tr -d '[:space:]')

if test -z "$code"
    notify-send "Auth Code" "No code found"
    exit 1
end

echo $code
echo $code | wl-copy
notify-send "Auth Code" $code
