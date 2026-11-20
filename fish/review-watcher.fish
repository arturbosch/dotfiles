#!/usr/bin/env fish
# Polls the repos under ~/git/forgejo/* for open PRs and runs a headless,
# sandboxed pi review agent (`pir`) on new PRs and new pushes (detected by a
# changed head sha). One review runs at a time; state survives restarts; a
# failed review is retried on the next pass and given up after 3 attempts.
#
#   review-watcher.fish           poll loop, every 30s (Ctrl-C to stop)
#   review-watcher.fish --once    one pass and exit
#
# state:  ~/.local/state/review-watcher/<repo>.sp      pr sha attempts per line
# log:    ~/.local/state/review-watcher/watcher.log   start/end/give-up lines
# output: ~/.local/state/review-watcher/logs/<repo>-pr<n>-<ts>.log

set -g state_dir $HOME/.local/state/review-watcher
set -g sandbox_fish $HOME/dotfiles/fish/sandbox.fish
set -g poll_interval 120
set -g max_attempts 3
set -g review_timeout 1800

# logs to watcher.log and the console (stderr) at the same time
function log
    echo (date '+%Y-%m-%dT%H:%M:%S') $argv | tee --append $state_dir/watcher.log >&2
end

function run_review
    set -l dir $argv[1]
    set -l repo $argv[2]
    set -l n $argv[3]
    set -l sha $argv[4]
    set -l url $argv[5]
    set -l ts (date +%s)
    set -l out_log $state_dir/logs/$repo-pr$n-$ts.log
    log "start repo=$repo pr=$n sha=$sha url=$url"
    timeout --kill-after=60 $review_timeout \
        fish -c "source $sandbox_fish; cd $dir; and pir 'Code review $url. Fix found issues as fixup commits. Nitpick comments on the specific line. Summary comment if needed.'" >>$out_log 2>&1
    set -l code $status
    set -l dur (math (date +%s) - $ts)
    log "end repo=$repo pr=$n exit=$code dur={$dur}s log=$out_log"
    test $code -eq 0
end

function pass
    for dir in $HOME/git/forgejo/*
        test -d "$dir/.git"; or continue
        set -l remote (git -C $dir remote get-url origin 2>/dev/null)
        if test $status -ne 0
            continue
        end
        # ssh://git@git.home:2222/artur/<repo>.git → last two path segments
        set -l owner_repo (string replace -r '\.git$' '' -- $remote | string split /)[-2..-1]
        set -l owner $owner_repo[1]
        set -l repo $owner_repo[2]
        set -l sock $HOME/.local/run/toolsocks/$repo.sock
        test -S $sock; or continue

        # the forgejo-cli call is the one thing that can hang forever without a
        # timeout of its own (broker unreachable, git.home slow) — cap it
        set -l raw (timeout 60 forgejo-cli --socket $sock pr list --state open --full 2>/dev/null)
        if test $status -ne 0
            log "warn repo=$repo: pr list failed or timed out (exit=$status)"
            continue
        end
        # space separator: fish does not expand \t inside double quotes, so
        # tabs are a trap here — numbers and hex shas contain no spaces anyway
        set -l pr_lines (echo "$raw" | jq -r '.[] | "\(.number) \(.head.sha)"' 2>/dev/null)
        if test $status -ne 0
            # never continue with an empty parse: that would prune state and
            # re-review every open PR on the next pass
            log "warn repo=$repo: could not parse pr list output"
            continue
        end
        set -l pr_count (count $pr_lines)
        log "scan repo=$repo: $pr_count open PR(s)"

        set -l state_file $state_dir/$repo.sp
        set -l new_state
        for line in $pr_lines
            set -l parts (string split " " -- $line)
            set -l n $parts[1]
            set -l sha $parts[2]
            set -l prev (cat $state_file 2>/dev/null | string match "$n *")
            set -l attempts 0
            set -l prev_sha ''
            if test -n "$prev"
                set -l p (string split " " -- $prev)
                set prev_sha $p[2]
                set attempts $p[3]
            end
            if test "$prev_sha" = "$sha"
                # already reviewed (success or gave up) at this head
                log "skip repo=$repo pr=$n sha=$sha attempts=$attempts"
                set -a new_state "$n $sha $attempts"
                continue
            end
            # new PR or new push: fresh attempt counter for the new head
            set attempts 0
            set -l url https://git.home/$owner/$repo/pulls/$n
            log "trigger repo=$repo pr=$n sha=$sha url=$url"
            run_review $dir $repo $n $sha $url
            if test $status -ne 0
                set attempts (math $attempts + 1)
                if test $attempts -ge $max_attempts
                    log "give-up repo=$repo pr=$n sha=$sha after $attempts failed attempts"
                end
            end
            set -a new_state "$n $sha $attempts"
        end
        # state lists only currently open PRs — closed ones are pruned here
        if test (count $new_state) -gt 0
            string join "\n" -- $new_state >$state_file
        else
            rm -f $state_file
        end
    end
end

mkdir -p $state_dir/logs

if test "$argv[1]" = --once
    pass
    exit 0
end

log "watcher started pid=$fish_pid interval=$poll_interval s"
while true
    pass
    sleep $poll_interval
end
