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
# Two conventions run through every entry, and the box says so underneath:
#
#   CAPITALS   a word you replace: FILE, FOLDER, PATTERN, NUMBER
#   [ ]        a part you can leave out
#
# Lessons that teach an idea rather than a command — a deadlock, a zombie, a
# page fault — have no entry here, and no box is drawn for them.

# One line of the shape. Several calls make a multi-line shape, which is what
# `if` and `for` need.
format_shape() {
    printf '  %b%s%b\n' "${CYAN:-}" "$1" "${RESET:-}"
}

# One worked example, and what it does in plain words.
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
        format_example 'ls' 'what is in the folder you are in'
        format_example 'ls Documents' 'what is in Documents'
        ;;
    'ls -l')
        format_shape 'ls -l [FILE or FOLDER]'
        format_gap
        format_example 'ls -l' 'one line each: permissions, owner, size, date'
        format_example 'ls -l report.txt' 'those details for one file'
        ;;
    'ls -la')
        format_shape 'ls -la [FOLDER]'
        format_gap
        format_example 'ls -la' 'the long listing, hidden files included'
        format_example 'ls -la Documents' 'the same, for another folder'
        ;;
    'cd')
        format_shape 'cd FOLDER'
        format_gap
        format_example 'cd Documents' 'go into Documents'
        format_example 'cd projects/notes' 'go two folders deep in one step'
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
        format_example 'cat welcome.txt' 'print the whole file'
        format_example 'cat a.txt b.txt' 'print both, one after the other'
        ;;
    'less')
        format_shape 'less FILE'
        format_gap
        format_example 'less system.log' 'read a long file a screen at a time'
        format_example 'q' 'the key that gets you back out'
        ;;
    'mkdir')
        format_shape 'mkdir [-p] FOLDER'
        format_gap
        format_example 'mkdir mission' 'make one folder here'
        format_example 'mkdir -p a/b/c' 'make the whole path, parents and all'
        ;;
    'touch')
        format_shape 'touch FILE'
        format_gap
        format_example 'touch secret.txt' 'make an empty file'
        ;;
    'cp')
        format_shape 'cp SOURCE DESTINATION'
        format_gap
        format_example 'cp notes.txt backup.txt' 'copy to a new name'
        format_example 'cp notes.txt Documents/' 'copy into a folder, same name'
        ;;
    'mv')
        format_shape 'mv SOURCE DESTINATION'
        format_gap
        format_example 'mv food.txt snacks.txt' 'rename it'
        format_example 'mv notes.txt Documents/' 'move it somewhere else'
        ;;
    'rm')
        format_shape 'rm [-r] FILE'
        format_gap
        format_example 'rm junk.txt' 'delete one file, for good'
        format_example 'rm -r oldfolder' 'delete a folder and everything in it'
        ;;

    # ── Stage 2: reading and searching ─────────────────────
    'head')
        format_shape 'head [-n NUMBER] FILE'
        format_gap
        format_example 'head system.log' 'the first 10 lines'
        format_example 'head -n 3 notes.txt' 'the first 3 lines'
        ;;
    'tail')
        format_shape 'tail [-n NUMBER] FILE'
        format_gap
        format_example 'tail system.log' 'the last 10 lines — the newest ones'
        format_example 'tail -n 3 notes.txt' 'the last 3 lines'
        ;;
    'wc')
        format_shape 'wc [-l] [-w] [-c] FILE'
        format_gap
        format_example 'wc -l system.log' 'how many lines'
        format_example 'wc -w notes.txt' 'how many words'
        ;;
    'grep')
        format_shape 'grep PATTERN FILE'
        format_gap
        format_example 'grep ERROR system.log' 'every line containing ERROR'
        format_example 'grep "two words" notes.txt' 'quote a pattern with a space in it'
        ;;
    'grep -i')
        format_shape 'grep -i PATTERN FILE'
        format_gap
        format_example 'grep -i sunbeam naps.txt' 'matches Sunbeam, SUNBEAM, sunbeam'
        ;;
    'grep -n')
        format_shape 'grep -n PATTERN FILE'
        format_gap
        format_example 'grep -n ERROR system.log' 'each match with its line number'
        ;;
    'grep -r')
        format_shape 'grep -r PATTERN FOLDER'
        format_gap
        format_example 'grep -r garden inbox' 'search every file under inbox'
        ;;
    'find')
        format_shape 'find FOLDER'
        format_gap
        format_example 'find .' 'every file and folder below where you are'
        format_example 'find Documents' 'everything below Documents'
        ;;
    'find -name')
        format_shape 'find FOLDER -name "PATTERN"'
        format_gap
        format_example 'find . -name "*.log"' 'every file ending in .log'
        format_example 'find . -name "notes.txt"' 'every file with that exact name'
        ;;
    '|')
        format_shape 'COMMAND | COMMAND'
        format_gap
        format_example 'grep ERROR log | wc -l' 'count the lines grep found'
        format_example 'ls | head -n 3' 'the first three names ls printed'
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
        format_example 'stat report.txt' 'size, owner, permissions, timestamps'
        ;;
    'chmod')
        format_shape 'chmod NUMBER FILE'
        format_gap
        format_example 'chmod 600 draft.txt' 'you read and write; nobody else anything'
        format_example 'chmod 644 notes.txt' 'you read and write; others read'
        format_example '' '4 = read, 2 = write, 1 = run. Add them up.'
        ;;
    'chmod +/-')
        format_shape 'chmod WHO+PERMISSION FILE'
        format_gap
        format_example 'chmod g+r draft.txt' 'add read, for the group'
        format_example 'chmod o-w notes.txt' 'take write away from everyone else'
        format_example '' 'WHO is u (you), g (group), o (others), a (all)'
        ;;
    'chmod +x')
        format_shape 'chmod +x FILE'
        format_gap
        format_example 'chmod +x greet.sh' 'make a script runnable'
        ;;
    'chown')
        format_shape 'chown USER FILE'
        format_gap
        format_example 'chown catplayer report.txt' 'hand the file to another user'
        format_example '' 'Only root can give a file away'
        ;;

    # ── Stage 4: output, order, processes ──────────────────
    'echo')
        format_shape 'echo TEXT'
        format_gap
        format_example 'echo meow' 'print it back'
        format_example 'echo "two words"' 'quote it to keep it as one piece'
        ;;
    '>')
        format_shape 'COMMAND > FILE'
        format_gap
        format_example 'echo catplayer > owner.txt' 'write it to the file'
        format_example '' 'The file is emptied first. Careful.'
        ;;
    '>>')
        format_shape 'COMMAND >> FILE'
        format_gap
        format_example 'echo stage4 >> owner.txt' 'add to the end, keeping what is there'
        ;;
    'sort')
        format_shape 'sort [-n] [-h] FILE'
        format_gap
        format_example 'sort sightings.txt' 'alphabetical order'
        format_example 'sort -n numbers.txt' 'numerical order, so 9 comes before 10'
        ;;
    'uniq')
        format_shape 'uniq [-c] FILE'
        format_gap
        format_example 'uniq sightings.txt' 'drop repeated lines that sit together'
        format_example '' 'It only sees neighbours, so sort first'
        ;;
    'sort | uniq -c')
        format_shape 'sort FILE | uniq -c'
        format_gap
        format_example 'sort sightings.txt | uniq -c' 'how many times each line appears'
        ;;
    'ps')
        format_shape 'ps [OPTIONS]'
        format_gap
        format_example 'ps' 'the programs running in this terminal'
        ;;
    '&')
        format_shape 'COMMAND &'
        format_gap
        format_example 'sleep 300 &' 'run it in the background, get the prompt back'
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
        format_example 'the first line of a script' 'says which program runs the rest'
        ;;
    './script.sh')
        format_shape './SCRIPT.sh [ARGUMENTS]'
        format_gap
        format_example './hello.sh' 'run a script in this folder'
        format_example '' 'It needs chmod +x first, and the ./ is not optional'
        ;;
    'NAME=value')
        format_shape 'NAME=value'
        format_shape 'echo $NAME'
        format_gap
        format_example 'CAT=mochi' 'no spaces around the ='
        format_example 'echo $CAT' 'the $ is how you read it back'
        ;;
    '$1')
        format_shape '$1  $2  $3 ...'
        format_gap
        format_example 'echo hello $1' 'inside a script: the first word after its name'
        format_example './greet.sh Ajay' 'so $1 is Ajay'
        ;;
    'if')
        format_shape 'if [ TEST ]; then'
        format_shape '    COMMAND'
        format_shape 'fi'
        format_gap
        format_example '[ -f data.txt ]' 'true when that file exists'
        format_example '[ -d reports ]' 'true when that folder exists'
        format_example '[ -z "$1" ]' 'true when $1 is empty'
        ;;
    'for')
        format_shape 'for NAME in LIST; do'
        format_shape '    COMMAND'
        format_shape 'done'
        format_gap
        format_example 'for X in a b c; do' 'X becomes a, then b, then c'
        format_example 'echo $X' 'the body runs once for each'
        ;;
    'if + for')
        format_shape 'for NAME in LIST; do'
        format_shape '    if [ TEST ]; then'
        format_shape '        COMMAND'
        format_shape '    fi'
        format_shape 'done'
        format_gap
        format_example 'for F in *.txt; do' 'every .txt file in turn'
        format_example 'if [ -f "$F" ]; then' 'the inner block closes first: fi, then done'
        ;;

    # ── Stage 6: cutting text up ───────────────────────────
    'cut')
        format_shape 'cut -cRANGE FILE'
        format_gap
        format_example 'cut -c1-6 inventory.txt' 'characters 1 to 6 of every line'
        ;;
    'cut -d -f')
        format_shape 'cut -d DELIMITER -f NUMBER FILE'
        format_gap
        format_example 'cut -d: -f1 inventory.txt' 'the first field, split on :'
        format_example 'cut -d, -f2 data.csv' 'the second field, split on a comma'
        ;;
    'tr')
        format_shape 'cat FILE | tr FROM TO'
        format_gap
        format_example 'cat data.txt | tr : ,' 'every colon becomes a comma'
        format_example '' 'tr reads what is piped in, not a filename'
        ;;
    'nl')
        format_shape 'nl FILE'
        format_gap
        format_example 'nl memo.txt' 'the file with a line number on each line'
        ;;
    'sed')
        format_shape "sed 's/OLD/NEW/' FILE"
        format_gap
        format_example "sed 's/dog/cat/' memo.txt" 'the first dog on each line becomes cat'
        format_example '' 'It prints the change; the file is untouched'
        ;;
    'sed s///g')
        format_shape "sed 's/OLD/NEW/g' FILE"
        format_gap
        format_example "sed 's/the/a/g' memo.txt" 'the g means every match, not just the first'
        ;;
    'sed /d')
        format_shape "sed '/PATTERN/d' FILE"
        format_gap
        format_example "sed '/sofa/d' memo.txt" 'print the file without lines mentioning sofa'
        ;;
    'awk')
        format_shape "awk -F SEPARATOR '{print \$1, \$2}' FILE"
        format_gap
        format_example "awk -F: '{print \$1}' data.txt" 'the first field of every line'
        format_example '' 'Here $1 is a column, not a script argument'
        ;;
    'awk condition')
        format_shape "awk -F SEPARATOR 'CONDITION {print \$1}' FILE"
        format_gap
        format_example "awk -F: '\$3 > 5 {print \$1}'" 'only lines whose 3rd field is over 5'
        ;;

    # ── Stage 7: finding and packing ───────────────────────
    'find -type')
        format_shape 'find FOLDER -type d'
        format_shape 'find FOLDER -type f'
        format_gap
        format_example 'find . -type d' 'folders only'
        format_example 'find . -type f' 'files only'
        ;;
    'find -size')
        format_shape 'find FOLDER -size +SIZE'
        format_gap
        format_example 'find . -size +10k' 'bigger than 10 kilobytes'
        format_example 'find . -size -1M' 'smaller than a megabyte'
        ;;
    'find -mmin')
        format_shape 'find FOLDER -mmin -MINUTES'
        format_gap
        format_example 'find . -mmin -60' 'changed in the last hour'
        format_example 'find . -mmin +60' 'not touched for over an hour'
        ;;
    'find -exec')
        format_shape 'find FOLDER -name "PATTERN" -exec COMMAND {} \;'
        format_gap
        format_example 'find . -exec wc -l {} \;' 'run wc -l on everything it finds'
        format_example '' '{} is the file it found; the \; ends the command'
        ;;
    'xargs')
        format_shape 'COMMAND | xargs COMMAND'
        format_gap
        format_example 'find . -name "*.md" | xargs wc -l' 'hand every result to wc at once'
        ;;
    'du')
        format_shape 'du [-s] [-h] FOLDER'
        format_gap
        format_example 'du -sh media' 'one human-readable total for the folder'
        format_example 'du -h media' 'a size for every folder inside it too'
        ;;
    'du | sort')
        format_shape 'du -h FOLDER/* | sort -h'
        format_gap
        format_example 'du -h media/* | sort -h' 'biggest last, sizes read as sizes'
        ;;
    'df')
        format_shape 'df [-h]'
        format_gap
        format_example 'df -h' 'how full each disk is, in K, M and G'
        ;;
    'ln -s')
        format_shape 'ln -s TARGET LINKNAME'
        format_gap
        format_example 'ln -s notes.md shortcut.md' 'shortcut.md now points at notes.md'
        ;;
    'tar -cf')
        format_shape 'tar -cf ARCHIVE.tar FOLDER'
        format_gap
        format_example 'tar -cf papers.tar documents' 'pack the folder into one file'
        format_example '' 'c = create, f = the archive filename'
        ;;
    'tar -tf')
        format_shape 'tar -tf ARCHIVE.tar'
        format_gap
        format_example 'tar -tf papers.tar' 'list what is inside, unpacking nothing'
        ;;
    'tar -xf')
        format_shape 'tar -xf ARCHIVE.tar'
        format_gap
        format_example 'tar -xf papers.tar' 'unpack it here — x for extract'
        ;;
    'tar -czf')
        format_shape 'tar -czf ARCHIVE.tar.gz FOLDER'
        format_gap
        format_example 'tar -czf papers.tar.gz docs' 'pack and compress in one go'
        format_example 'tar -xzf papers.tar.gz' 'and back out again'
        ;;
    'gzip')
        format_shape 'gzip FILE'
        format_gap
        format_example 'gzip bigfile.txt' 'becomes bigfile.txt.gz; the original goes'
        format_example 'gunzip bigfile.txt.gz' 'and comes back'
        ;;
    'diff')
        format_shape 'diff FILE1 FILE2'
        format_gap
        format_example 'diff charter.txt charter_v2.txt' 'what changed between the two'
        format_example '' 'Prints nothing when they are the same'
        ;;
    'diff -u')
        format_shape 'diff -u FILE1 FILE2'
        format_gap
        format_example 'diff -u old.txt new.txt' 'the same, in the format patches use'
        ;;
    'sha256sum')
        format_shape 'sha256sum FILE'
        format_gap
        format_example 'sha256sum charter.txt' 'a fingerprint of the contents'
        format_example 'sha256sum f > f.sha256' 'keep it to check the file later'
        ;;
    'sha256sum -c')
        format_shape 'sha256sum -c CHECKSUMFILE'
        format_gap
        format_example 'sha256sum -c charter.sha256' 'says OK, or says the file changed'
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
        format_example 'export CATNAME=Mochi' 'set it, and pass it to what you run'
        format_example 'echo $CATNAME' 'read it back'
        ;;
    'PATH')
        format_shape 'echo $PATH'
        format_gap
        format_example 'echo $PATH' 'the folders searched for commands, in order'
        ;;
    'which')
        format_shape 'which COMMAND'
        format_gap
        format_example 'which grep' 'the file that runs when you type grep'
        ;;
    'which bash')
        format_shape 'which COMMAND'
        format_gap
        format_example 'which bash' 'where the shell itself lives'
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
        format_example 'mkdir archive && ls archive' 'run the second only if the first worked'
        ;;
    '||')
        format_shape 'COMMAND || COMMAND'
        format_gap
        format_example 'cat missing.txt || echo not found' 'run the second only if the first failed'
        ;;
    ';')
        format_shape 'COMMAND ; COMMAND'
        format_gap
        format_example 'pwd ; ls' 'run both, whatever the first one does'
        ;;
    '$(...)')
        format_shape '$(COMMAND)'
        format_gap
        format_example 'echo I am $(whoami)' 'run it, and drop its output in place'
        format_example 'wc -l < $(ls | head -1)' 'the inside runs first, every time'
        ;;
    'tee')
        format_shape 'COMMAND | tee FILE'
        format_gap
        format_example 'ls | tee listing.txt' 'to the screen and into the file, at once'
        ;;
    'basename')
        format_shape 'basename PATH'
        format_gap
        format_example 'basename site/pages.txt' 'prints pages.txt — the name, not the path'
        ;;
    'mktemp')
        format_shape 'mktemp'
        format_gap
        format_example 'mktemp' 'makes a scratch file and prints its name'
        ;;
    'exit')
        format_shape 'exit [NUMBER]'
        format_gap
        format_example 'exit 0' 'end the script, saying it worked'
        format_example 'exit 1' 'end it, saying it did not'
        ;;
    'if [ -z $1 ]')
        format_shape 'if [ -z "$1" ]; then'
        format_shape '    echo needs an argument'
        format_shape '    exit 1'
        format_shape 'fi'
        format_gap
        format_example '[ -z "$1" ]' 'true when nothing was passed in'
        format_example '' 'Quote "$1", or an empty one leaves the test malformed'
        ;;
    'for F in $(find ...)')
        format_shape 'for F in $(find FOLDER -name "PATTERN"); do'
        format_shape '    COMMAND "$F"'
        format_shape 'done'
        format_gap
        format_example 'for F in $(find . -type f); do' 'each file find returns, in turn'
        ;;
    'set -euo pipefail')
        format_shape 'set -euo pipefail'
        format_gap
        format_example 'set -euo pipefail' 'stop on the first error, not the last'
        format_example '' 'Goes at the top, under the #! line'
        ;;

    # ── Stages 11-15: asking the system about itself ───────
    'uname')
        format_shape 'uname [-a]'
        format_gap
        format_example 'uname -a' 'kernel, version, machine — all of it'
        ;;
    '/proc/cpuinfo')
        format_shape 'cat /proc/cpuinfo'
        format_gap
        format_example 'cat /proc/cpuinfo' 'what the kernel knows about the CPU'
        format_example '' '/proc is not on a disk: it is the kernel answering'
        ;;
    '/proc/PID')
        format_shape 'cat /proc/PID/FILE'
        format_gap
        format_example 'cat /proc/self/cmdline' 'self means the process doing the asking'
        format_example 'cat /proc/4823/status' 'the same questions, about another process'
        ;;
    '/proc/self/maps')
        format_shape 'cat /proc/self/maps'
        format_gap
        format_example 'cat /proc/self/maps' 'every stretch of memory a process can see'
        ;;
    'ps -o pid,ppid')
        format_shape 'ps -o COLUMN,COLUMN,...'
        format_gap
        format_example 'ps -o pid,ppid,comm' 'process, its parent, and the command'
        ;;
    'ps -o stat')
        format_shape 'ps -o pid,stat,comm'
        format_gap
        format_example 'ps -o pid,stat,comm' 'what state each process is in'
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
        format_example 'nice -n 10 sleep 60 &' 'run it, but let others go first'
        format_example '' 'Higher number = nicer = lower priority'
        ;;
    'free -h')
        format_shape 'free -h'
        format_gap
        format_example 'free -h' 'memory used, free, and held as cache'
        ;;
    'exec')
        format_shape 'exec COMMAND'
        format_gap
        format_example 'exec ls' 'replace this process with that one'
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
