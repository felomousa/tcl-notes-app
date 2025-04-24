#!/usr/bin/env wish
package require sqlite3

# script folder & db path
set scriptDir [file dirname [info script]]
set dbPath    [file join $scriptDir notes.db]

# open as db
sqlite3 db $dbPath

# ensure notes table exists
db eval {
    CREATE TABLE IF NOT EXISTS notes (
        id     INTEGER PRIMARY KEY,
        title  TEXT,
        body   TEXT,
        tags   TEXT
    )
}

db close
