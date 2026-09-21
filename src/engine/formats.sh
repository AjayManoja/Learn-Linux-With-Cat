#!/usr/bin/env bash
set -euo pipefail

# formats.sh — the shape of every command the game teaches.
#
# A lesson explains what a command is for, in sentences. That leaves a
# beginner knowing what `head` does and still not sure what goes where: which
# part is the command, which part is theirs to fill in, and which part can be
# left out entirely. This is the missing line — the command written out as a
# pattern, with one or two worked examples underneath.
#
# The table is keyed by LESSON_COMMAND, so a lesson gets its format by saying
# what it teaches, which it already does. A lesson that wants to write its
# own sets LESSON_FORMAT instead.
#
# Two conventions run through the shapes:
#
#   CAPITALS   a word the player replaces: FILE, FOLDER, PATTERN, NUMBER
#   [ ]        a part that can be left out
#
# One rule runs through the examples, and tests/test_formats.sh enforces it:
# an example never uses the files, folders or words the lesson's own task
# asks for. The box is there to show the shape of a command, not to hand over
# the answer to the exercise underneath it — a player who copies the example
# and finds the task complete has learnt nothing. So the task works on
# system.log and the example works on app.log, and the player has to make the
# jump themselves. That jump is the lesson.
#
# Lessons that teach an idea rather than a command — a deadlock, a zombie, a
# page fault — have no entry here, and no box is drawn for them.

# One line of the shape. Several calls make a multi-line shape, which is what
# `if` and `for` need.
format_shape() {
    printf '  %b%s%b\n' "${CYAN:-}" "$1" "${RESET:-}"
}

# One worked example, and what it does in plain words. An example with no
# command in it is a note, and lines up under the ones that have.
format_example() {
    printf '  %-34s %b%s%b\n' "$1" "${DIM:-}" "$2" "${RESET:-}"
}

# A blank line between the shape and the examples, printed by the caller so
# an entry with no examples does not end in one.
format_gap() {
    printf '\n'
}

# The body of the box for one command, or nothing at all if the game has no
# format for it.
command_format_lines() {
    case "${1:-}" in

    # ── Stage 1: getting around ────────────────────────────
    'pwd')
        format_shape 'pwd'
        format_gap
        format_example 'pwd' 'print the folder you are standing in'
        ;;
    'ls')
        format_shape 'ls [OPTIONS] [FOLDER]'
        format_gap
        format_example 'ls photos' 'what is in the photos folder'
        format_example 'ls -r photos' 'the same, in reverse order'
        ;;
    'ls -l')
        format_shape 'ls -l [FILE or FOLDER]'
        format_gap
        format_example 'ls -l photos' 'one line each: permissions, owner, size, date'
        format_example 'ls -l budget.csv' 'those details for one file'
        ;;
    'ls -la')
        format_shape 'ls -la [FOLDER]'
        format_gap
        format_example 'ls -la photos' 'the long listing, hidden files included'
        format_example 'ls -a photos' 'hidden files, but not the details'
        ;;
    'cd')
        format_shape 'cd FOLDER'
        format_gap
        format_example 'cd photos' 'go into photos'
        format_example 'cd photos/holiday' 'go two folders deep in one step'
        ;;
    'cd ..')
        format_shape 'cd ..'
        format_gap
        format_example 'cd ..' 'go up one folder, towards /'
        format_example 'cd ../..' 'go up two'
        ;;
    'cd ~')
        format_shape 'cd ~'
        format_gap
        format_example 'cd ~' 'go home, from wherever you are'
        ;;
    'cat')
        format_shape 'cat FILE [FILE...]'
        format_gap
        format_example 'cat diary.txt' 'print the whole file'
        format_example 'cat part1.txt part2.txt' 'print both, one after the other'
        ;;
    'less')
        format_shape 'less FILE'
        format_gap
        format_example 'less app.log' 'read a long file a screen at a time'
        format_example 'q' 'the key that gets you back out'
        ;;
    'mkdir')
        format_shape 'mkdir [-p] FOLDER'
        format_gap
        format_example 'mkdir photos' 'make one folder here'
        format_example 'mkdir -p photos/2024/june' 'make the whole path, parents and all'
        ;;
    'touch')
        format_shape 'touch FILE'
        format_gap
        format_example 'touch draft.txt' 'make an empty file'
        ;;
    'cp')
        format_shape 'cp SOURCE DESTINATION'
        format_gap
        format_example 'cp diary.txt diary_old.txt' 'copy to a new name'
        format_example 'cp diary.txt photos/' 'copy into a folder, same name'
        ;;
    'mv')
        format_shape 'mv SOURCE DESTINATION'
        format_gap
        format_example 'mv draft.txt final.txt' 'rename it'
        format_example 'mv final.txt photos/' 'move it somewhere else'
        ;;
    'rm')
        format_shape 'rm [-r] FILE'
        format_gap
        format_example 'rm scratch.txt' 'delete one file, for good'
        format_example 'rm -r old_photos' 'delete a folder and everything in it'
        ;;

    # ── Stage 2: reading and searching ─────────────────────
    'head')
        format_shape 'head [-n NUMBER] FILE'
        format_gap
        format_example 'head app.log' 'the first 10 lines'
        format_example 'head -n 5 diary.txt' 'the first 5 lines'
        ;;
    'tail')
        format_shape 'tail [-n NUMBER] FILE'
        format_gap
        format_example 'tail app.log' 'the last 10 lines — the newest ones'
        format_example 'tail -n 5 diary.txt' 'the last 5 lines'
        ;;
    'wc')
        format_shape 'wc [-l] [-w] [-c] FILE'
        format_gap
        format_example 'wc -l story.txt' 'how many lines'
        format_example 'wc -w story.txt' 'how many words'
        ;;
    'grep')
        format_shape 'grep PATTERN FILE'
        format_gap
        format_example 'grep rain diary.txt' 'every line containing rain'
        format_example 'grep "two words" diary.txt' 'quote a pattern with a space in it'
        ;;
    'grep -i')
        format_shape 'grep -i PATTERN FILE'
        format_gap
        format_example 'grep -i rain diary.txt' 'matches Rain, RAIN and rain'
        ;;
    'grep -n')
        format_shape 'grep -n PATTERN FILE'
        format_gap
        format_example 'grep -n rain diary.txt' 'each match with its line number'
        ;;
    'grep -r')
        format_shape 'grep -r PATTERN FOLDER'
        format_gap
        format_example 'grep -r rain letters' 'search every file under letters'
        ;;
    'find')
        format_shape 'find FOLDER'
        format_gap
        format_example 'find photos' 'every file and folder below photos'
        format_example 'find photos/holiday' 'everything below one folder deeper'
        ;;
    'find -name')
        format_shape 'find FOLDER -name "PATTERN"'
        format_gap
        format_example 'find photos -name "*.jpg"' 'every file ending in .jpg'
        format_example 'find photos -name "cat.jpg"' 'every file with that exact name'
        ;;
    '|')
        format_shape 'COMMAND | COMMAND'
        format_gap
        format_example 'grep rain diary.txt | wc -l' 'count the lines grep found'
        format_example 'ls | tail -n 2' 'the last two names ls printed'
        ;;

    # ── Stage 3: who you are, what you may do ──────────────
    'whoami')
        format_shape 'whoami'
        format_gap
        format_example 'whoami' 'the name you are logged in as'
        ;;
    'id')
        format_shape 'id [USER]'
        format_gap
        format_example 'id' 'your user id, and every group you are in'
        ;;
    'stat')
        format_shape 'stat FILE'
        format_gap
        format_example 'stat holiday.jpg' 'size, owner, permissions, timestamps'
        ;;
    'chmod')
        format_shape 'chmod NUMBER FILE'
        format_gap
        format_example 'chmod 700 diary.txt' 'you read, write and run; nobody else anything'
        format_example 'chmod 644 holiday.jpg' 'you read and write; others read'
        format_example '' '4 = read, 2 = write, 1 = run. Add them up.'
        ;;
    'chmod +/-')
        format_shape 'chmod WHO+PERMISSION FILE'
        format_gap
        format_example 'chmod u+x backup.sh' 'add run, for you'
        format_example 'chmod o-r diary.txt' 'take read away from everyone else'
        format_example '' 'WHO is u (you), g (group), o (others), a (all)'
        ;;
    'chmod +x')
        format_shape 'chmod +x FILE'
        format_gap
        format_example 'chmod +x backup.sh' 'make a script runnable'
        ;;
    'chown')
        format_shape 'chown USER FILE'
        format_gap
        format_example 'chown ada budget.csv' 'hand the file to another user'
        format_example '' 'Only root can give a file away'
        ;;

    # ── Stage 4: output, order, processes ──────────────────
    'echo')
        format_shape 'echo TEXT'
        format_gap
        format_example 'echo hello' 'print it back'
        format_example 'echo "two words"' 'quote it to keep it as one piece'
        ;;
    '>')
        format_shape 'COMMAND > FILE'
        format_gap
        format_example 'echo hello > greeting.txt' 'write it to the file'
        format_example '' 'The file is emptied first. Careful.'
        ;;
    '>>')
        format_shape 'COMMAND >> FILE'
        format_gap
        format_example 'echo again >> greeting.txt' 'add to the end, keeping what is there'
        ;;
    'sort')
        format_shape 'sort [-n] [-h] FILE'
        format_gap
        format_example 'sort names.txt' 'alphabetical order'
        format_example 'sort -n scores.txt' 'numerical order, so 9 comes before 10'
        ;;
    'uniq')
        format_shape 'uniq [-c] FILE'
        format_gap
        format_example 'uniq names.txt' 'drop repeated lines that sit together'
        format_example '' 'It only sees neighbours, so sort first'
        ;;
    'sort | uniq -c')
        format_shape 'sort FILE | uniq -c'
        format_gap
        format_example 'sort names.txt | uniq -c' 'how many times each line appears'
        ;;
    'ps')
        format_shape 'ps [OPTIONS]'
        format_gap
        format_example 'ps' 'the programs running in this terminal'
        ;;
    '&')
        format_shape 'COMMAND &'
        format_gap
        format_example 'sleep 60 &' 'run it in the background, get the prompt back'
        format_example '' 'It prints the PID — the number that names the job'
        ;;
    'kill')
        format_shape 'kill PID'
        format_gap
        format_example 'kill 4823' 'ask that process to stop'
        format_example '' 'ps is where you find the PID'
        ;;

    # ── Stage 5: writing scripts ───────────────────────────
    '#!')
        format_shape '#!/usr/bin/env bash'
        format_gap
        format_example '' 'goes on the very first line of a script'
        format_example '' 'it says which program runs the rest of the file'
        ;;
    './script.sh')
        format_shape './SCRIPT.sh [ARGUMENTS]'
        format_gap
        format_example './backup.sh' 'run a script in this folder'
        format_example '' 'It needs chmod +x first, and the ./ is not optional'
        ;;
    'NAME=value')
        format_shape 'NAME=value'
        format_shape 'echo $NAME'
        format_gap
        format_example 'COLOUR=ginger' 'no spaces around the ='
        format_example 'echo $COLOUR' 'the $ is how you read it back'
        ;;
    '$1')
        format_shape '$1  $2  $3 ...'
        format_gap
        format_example 'echo feeding $1' 'inside a script: the first word after its name'
        format_example './feed.sh mochi' 'so $1 is mochi'
        ;;
    'if')
        format_shape 'if [ TEST ]; then'
        format_shape '    COMMAND'
        format_shape 'fi'
        format_gap
        format_example '[ -f diary.txt ]' 'true when that file exists'
        format_example '[ -d photos ]' 'true when that folder exists'
        format_example '' 'The block ends with fi — if, backwards'
        ;;
    'for')
        format_shape 'for NAME in LIST; do'
        format_shape '    COMMAND'
        format_shape 'done'
        format_gap
        format_example 'for N in 1 2 3; do' 'N becomes 1, then 2, then 3'
        format_example 'echo $N' 'the body runs once for each'
        ;;
    'if + for')
        format_shape 'for NAME in LIST; do'
        format_shape '    if [ TEST ]; then'
        format_shape '        COMMAND'
        format_shape '    fi'
        format_shape 'done'
        format_gap
        format_example 'for F in *.md; do' 'every .md file in turn'
        format_example '' 'The inner block closes first: fi, then done'
        ;;

    # ── Stage 6: cutting text up ───────────────────────────
    'cut')
        format_shape 'cut -cRANGE FILE'
        format_gap
        format_example 'cut -c1-4 prices.csv' 'characters 1 to 4 of every line'
        ;;
    'cut -d -f')
        format_shape 'cut -d DELIMITER -f NUMBER FILE'
        format_gap
        format_example 'cut -d, -f2 prices.csv' 'the second field, split on a comma'
        format_example 'cut -d" " -f1 log.txt' 'the first word of every line'
        ;;
    'tr')
        format_shape 'cat FILE | tr FROM TO'
        format_gap
        format_example 'cat names.txt | tr a-z A-Z' 'every letter becomes a capital'
        format_example '' 'tr reads what is piped in, not a filename'
        ;;
    'nl')
        format_shape 'nl FILE'
        format_gap
        format_example 'nl chapter.txt' 'the file with a line number on each line'
        ;;
    'sed')
        format_shape "sed 's/OLD/NEW/' FILE"
        format_gap
        format_example "sed 's/red/blue/' colours.txt" 'the first red on each line becomes blue'
        format_example '' 'It prints the change; the file is untouched'
        ;;
    'sed s///g')
        format_shape "sed 's/OLD/NEW/g' FILE"
        format_gap
        format_example "sed 's/red/blue/g' colours.txt" 'the g means every match, not just the first'
        ;;
    'sed /d')
        format_shape "sed '/PATTERN/d' FILE"
        format_gap
        format_example "sed '/blue/d' colours.txt" 'print the file without lines mentioning blue'
        ;;
    'awk')
        format_shape "awk -F SEPARATOR '{print \$1, \$2}' FILE"
        format_gap
        format_example "awk -F, '{print \$2}' prices.csv" 'the second field of every line'
        format_example '' 'Here $1 is a column, not a script argument'
        ;;
    'awk condition')
        format_shape "awk -F SEPARATOR 'CONDITION {print \$1}' FILE"
        format_gap
        format_example "awk -F, '\$2 > 100 {print \$1}'" 'only lines whose 2nd field is over 100'
        ;;

    # ── Stage 7: finding and packing ───────────────────────
    'find -type')
        format_shape 'find FOLDER -type d'
        format_shape 'find FOLDER -type f'
        format_gap
        format_example 'find photos -type d' 'folders only'
        format_example 'find photos -type f' 'files only'
        ;;
    'find -size')
        format_shape 'find FOLDER -size +SIZE'
        format_gap
        format_example 'find photos -size +2M' 'bigger than two megabytes'
        format_example 'find photos -size -4k' 'smaller than four kilobytes'
        ;;
    'find -mmin')
        format_shape 'find FOLDER -mmin -MINUTES'
        format_gap
        format_example 'find letters -mmin -15' 'changed in the last quarter of an hour'
        format_example 'find letters -mmin +90' 'not touched for an hour and a half'
        ;;
    'find -exec')
        format_shape 'find FOLDER -name "PATTERN" -exec COMMAND {} \;'
        format_gap
        format_example 'find photos -exec stat {} \;' 'run stat on each one it finds'
        format_example '' '{} is the file it found; the \; ends the command'
        ;;
    'xargs')
        format_shape 'COMMAND | xargs COMMAND'
        format_gap
        format_example 'ls *.txt | xargs head -n 1' 'hand every name to head at once'
        ;;
    'du')
        format_shape 'du [-s] [-h] FOLDER'
        format_gap
        format_example 'du -sh photos' 'one human-readable total for the folder'
        format_example 'du -h photos' 'a size for every folder inside it too'
        ;;
    'du | sort')
        format_shape 'du -h FOLDER/* | sort -h'
        format_gap
        format_example 'du -h photos/* | sort -h' 'biggest last, sizes read as sizes'
        ;;
    'df')
        format_shape 'df [-h]'
        format_gap
        format_example 'df -h' 'how full each disk is, in K, M and G'
        ;;
    'ln -s')
        format_shape 'ln -s TARGET LINKNAME'
        format_gap
        format_example 'ln -s photos/cat.jpg last.jpg' 'last.jpg now points at photos/cat.jpg'
        ;;
    'tar -cf')
        format_shape 'tar -cf ARCHIVE.tar FOLDER'
        format_gap
        format_example 'tar -cf photos.tar photos' 'pack the folder into one file'
        format_example '' 'c = create, f = the archive filename'
        ;;
    'tar -tf')
        format_shape 'tar -tf ARCHIVE.tar'
        format_gap
        format_example 'tar -tf photos.tar' 'list what is inside, unpacking nothing'
        ;;
    'tar -xf')
        format_shape 'tar -xf ARCHIVE.tar'
        format_gap
        format_example 'tar -xf photos.tar' 'unpack it here — x for extract'
        ;;
    'tar -czf')
        format_shape 'tar -czf ARCHIVE.tar.gz FOLDER'
        format_gap
        format_example 'tar -czf photos.tar.gz photos' 'pack and compress in one go'
        format_example 'tar -xzf photos.tar.gz' 'and back out again'
        ;;
    'gzip')
        format_shape 'gzip FILE'
        format_gap
        format_example 'gzip diary.txt' 'becomes diary.txt.gz; the original goes'
        format_example 'gunzip diary.txt.gz' 'and comes back'
        ;;
    'diff')
        format_shape 'diff FILE1 FILE2'
        format_gap
        format_example 'diff draft1.txt draft2.txt' 'what changed between the two'
        format_example '' 'Prints nothing when they are the same'
        ;;
    'diff -u')
        format_shape 'diff -u FILE1 FILE2'
        format_gap
        format_example 'diff -u draft1.txt draft2.txt' 'the same, in the format patches use'
        ;;
    'sha256sum')
        format_shape 'sha256sum FILE'
        format_gap
        format_example 'sha256sum photos.tar.gz' 'a fingerprint of the contents'
        format_example 'sha256sum d.txt > d.sha256' 'keep it to check the file later'
        ;;
    'sha256sum -c')
        format_shape 'sha256sum -c CHECKSUMFILE'
        format_gap
        format_example 'sha256sum -c photos.sha256' 'says OK, or says the file changed'
        ;;

    # ── Stage 8: the environment ───────────────────────────
    'env')
        format_shape 'env'
        format_gap
        format_example 'env' 'every variable this shell hands to programs'
        ;;
    'export')
        format_shape 'export NAME=value'
        format_gap
        format_example 'export EDITOR=nano' 'set it, and pass it to what you run'
        format_example 'echo $EDITOR' 'read it back'
        ;;
    'PATH')
        format_shape 'echo $PATH'
        format_gap
        format_example 'echo $HOME' 'other variables read the same way'
        format_example 'echo $USER' 'the name the shell is running as'
        ;;
    'which')
        format_shape 'which COMMAND'
        format_gap
        format_example 'which python3' 'the file that runs when you type python3'
        ;;
    'which bash')
        format_shape 'which COMMAND'
        format_gap
        format_example 'which python3' 'where a program lives on the disk'
        format_example '' 'It searches $PATH, in the order $PATH lists'
        ;;

    # ── Stage 9: joining commands up ───────────────────────
    'echo $?')
        format_shape 'echo $?'
        format_gap
        format_example 'echo $?' 'the exit code of the last command'
        format_example '' '0 means it worked; anything else means it did not'
        ;;
    '&&')
        format_shape 'COMMAND && COMMAND'
        format_gap
        format_example 'mkdir photos && cd photos' 'run the second only if the first worked'
        ;;
    '||')
        format_shape 'COMMAND || COMMAND'
        format_gap
        format_example 'ls photos || mkdir photos' 'run the second only if the first failed'
        ;;
    ';')
        format_shape 'COMMAND ; COMMAND'
        format_gap
        format_example 'cd photos ; ls' 'run both, whatever the first one does'
        ;;
    '$(...)')
        format_shape '$(COMMAND)'
        format_gap
        format_example 'echo lines: $(wc -l < d.txt)' 'run it, and drop its output in place'
        format_example '' 'The inside runs first, every time'
        ;;
    'tee')
        format_shape 'COMMAND | tee FILE'
        format_gap
        format_example 'grep rain d.txt | tee found.txt' 'to the screen and into the file, at once'
        ;;
    'basename')
        format_shape 'basename PATH'
        format_gap
        format_example 'basename photos/cat.jpg' 'prints cat.jpg — the name, not the path'
        ;;
    'mktemp')
        format_shape 'mktemp'
        format_gap
        format_example 'mktemp' 'makes a scratch file and prints its name'
        ;;
    'exit')
        format_shape 'exit [NUMBER]'
        format_gap
        format_example 'exit 1' 'end the script, saying it failed'
        format_example '' '0 means it worked; anything else means it did not'
        ;;
    'if [ -z $1 ]')
        format_shape 'if [ -z "$1" ]; then'
        format_shape '    echo needs an argument'
        format_shape '    exit 1'
        format_shape 'fi'
        format_gap
        format_example '' '-z is true when the thing is empty'
        format_example '' 'Quote "$1", or an empty one leaves the test malformed'
        ;;
    'for F in $(find ...)')
        format_shape 'for F in $(find FOLDER -name "PATTERN"); do'
        format_shape '    COMMAND "$F"'
        format_shape 'done'
        format_gap
        format_example 'for F in $(find photos -type f); do' 'each file find returns, in turn'
        ;;
    'set -euo pipefail')
        format_shape 'set -euo pipefail'
        format_gap
        format_example '' '-e stop at the first command that fails'
        format_example '' '-u stop on a variable that was never set'
        format_example '' 'Goes at the top, under the #! line'
        ;;

    # ── Stages 11-15: asking the system about itself ───────
    'uname')
        format_shape 'uname [-a]'
        format_gap
        format_example 'uname -r' 'just the kernel version'
        format_example 'uname -m' 'just the machine type'
        ;;
    '/proc/cpuinfo')
        format_shape 'cat /proc/cpuinfo'
        format_gap
        format_example 'cat /proc/meminfo' 'the same questions, about memory'
        format_example 'cat /proc/uptime' 'seconds since the machine booted'
        format_example '' '/proc is not on a disk: it is the kernel answering'
        ;;
    '/proc/PID')
        format_shape 'cat /proc/PID/FILE'
        format_gap
        format_example 'cat /proc/1/comm' 'the name of process 1'
        format_example '' 'self is whichever process is doing the asking'
        ;;
    '/proc/self/maps')
        format_shape 'cat /proc/self/maps'
        format_gap
        format_example 'cat /proc/1/maps' 'the same, for another process'
        format_example '' 'Every stretch of memory a process can see'
        ;;
    'ps -o pid,ppid')
        format_shape 'ps -o COLUMN,COLUMN,...'
        format_gap
        format_example 'ps -o pid,user,comm' 'process, who owns it, and the command'
        ;;
    'ps -o stat')
        format_shape 'ps -o COLUMN,COLUMN,...'
        format_gap
        format_example 'ps -o pid,stat,user' 'the state column, next to the owner'
        format_example '' 'R running, S sleeping, T stopped, Z zombie'
        ;;
    'pstree')
        format_shape 'pstree'
        format_gap
        format_example 'pstree' 'every process, drawn under its parent'
        ;;
    'kill -l')
        format_shape 'kill -l'
        format_gap
        format_example 'kill -l' 'every signal you could send, by name'
        ;;
    'kill -9')
        format_shape 'kill -9 PID'
        format_gap
        format_example 'kill -9 4823' 'the one it cannot refuse or clean up after'
        format_example '' 'Try plain kill first; -9 is the last resort'
        ;;
    'kill -STOP')
        format_shape 'kill -STOP PID'
        format_shape 'kill -CONT PID'
        format_gap
        format_example 'kill -STOP 4823' 'freeze it where it stands'
        format_example 'kill -CONT 4823' 'and let it carry on'
        ;;
    'nproc')
        format_shape 'nproc'
        format_gap
        format_example 'nproc' 'how many CPUs this machine can run on at once'
        ;;
    'uptime')
        format_shape 'uptime'
        format_gap
        format_example 'uptime' 'how long it has been up, and the load average'
        ;;
    'nice')
        format_shape 'nice -n NUMBER COMMAND'
        format_gap
        format_example 'nice -n 15 gzip photos.tar' 'run it, but let others go first'
        format_example '' 'Higher number = nicer = lower priority'
        ;;
    'free -h')
        format_shape 'free -h'
        format_gap
        format_example 'free -h' 'memory used, free, and held as cache'
        format_example 'free -m' 'the same, counted in megabytes'
        ;;
    'exec')
        format_shape 'exec COMMAND'
        format_gap
        format_example 'exec bash' 'replace this process with that one'
        format_example '' 'Nothing after it runs: there is no going back'
        ;;

    *)
        return 0
        ;;
    esac
}

# What run_lesson prints. A lesson can write its own shape with LESSON_FORMAT
# — useful for a new lesson before its command has an entry above.
lesson_format_body() {
    if [[ -n "${LESSON_FORMAT:-}" ]]; then
        local line
        while IFS= read -r line; do
            format_shape "$line"
        done <<< "$LESSON_FORMAT"
        return 0
    fi

    command_format_lines "${LESSON_COMMAND:-}"
}
