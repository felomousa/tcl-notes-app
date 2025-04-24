#!/usr/bin/env wish
package require sqlite3
package require Tk

# db setup
set scriptDir [file dirname [info script]]
set dbPath [file join $scriptDir "notes.db"]
sqlite3 db $dbPath
db eval {
    CREATE TABLE IF NOT EXISTS notes (
        id     INTEGER PRIMARY KEY,
        title  TEXT,
        body   TEXT
    )
}

## ui setup
wm title . "tcl note manager"
frame .left; frame .right
pack .left .right -side left -fill both -expand 1 -padx 5 -pady 5

# left pane: list of note titles
scrollbar .left.sb -command ".left.lb yview"
listbox   .left.lb -yscrollcommand ".left.sb set" -width 25
pack .left.sb  -side right -fill y
pack .left.lb  -side left  -fill both -expand 1

# right pane: search box and action buttons
entry  .right.search  -width 40
button .right.btn_search -text "search" -command searchNote
button .right.btn_new    -text "new"    -command newNote
button .right.btn_save   -text "save"   -command saveNote
button .right.btn_delete -text "delete" -command deleteNote
pack .right.search .right.btn_search .right.btn_new .right.btn_save .right.btn_delete \
     -side top -fill x -padx 5 -pady 2

# editor for note body
scrollbar .right.sb2 -command ".right.text yview"
text      .right.text -yscrollcommand ".right.sb2 set" -wrap word -width 50 -height 20
pack .right.sb2   -side right -fill y
pack .right.text  -side left  -fill both -expand 1 -padx 5 -pady 5

# load titles into listbox
proc loadNotes {pattern} {
    .left.lb delete 0 end
    set titles [db eval "SELECT title FROM notes WHERE title LIKE '%$pattern%'"]
    foreach t $titles {
        .left.lb insert end $t
    }
}

# show selected note body in editor
proc loadNote {} {
    set sels [.left.lb curselection]
    if {[llength $sels] == 0} return
    set title [.left.lb get [lindex $sels 0]]
    set body  [lindex [db eval "SELECT body FROM notes WHERE title='$title'"] 0]
    .right.text delete 1.0 end
    .right.text insert end $body
}

# create a new note
proc newNote {} {
    set title [tk_getSaveFile -title "new note title"]
    if {$title eq ""} return
    db eval "INSERT INTO notes(title,body) VALUES('$title','')"
    loadNotes ""
    .left.lb selection set [expr {[.left.lb size] - 1}]
    loadNote
}

# save edits to current note
proc saveNote {} {
    set sels [.left.lb curselection]
    if {[llength $sels] == 0} return
    set title [.left.lb get [lindex $sels 0]]
    db eval "UPDATE notes SET body='[string map {\"'\" \"''\"} [.right.text get 1.0 end]]' WHERE title='$title'"
}

# delete selected note
proc deleteNote {} {
    set sels [.left.lb curselection]
    if {[llength $sels] == 0} return
    set title [.left.lb get [lindex $sels 0]]
    db eval "DELETE FROM notes WHERE title='$title'"
    .right.text delete 1.0 end
    loadNotes ""
}

# filter list by search entry
proc searchNote {} {
    loadNotes [.right.search get]
}

# clicking a title loads that note
bind .left.lb <ButtonRelease-1> {loadNote}

# initial load
loadNotes ""
