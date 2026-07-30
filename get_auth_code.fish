#!/usr/bin/env fish

if not test -f /tmp/latest_mail.html
    notify-send "Auth Code" "No email file found"
    exit 1
end

set code (cat /tmp/latest_mail.html | pi -p "Extract and print only the authentication code from this email. Print nothing else.")
set code (echo $code | tr -d '[:space:]')

if test -z "$code"
    notify-send "Auth Code" "No code found"
    exit 1
end

echo $code
echo $code | wl-copy
notify-send "Auth Code" $code
