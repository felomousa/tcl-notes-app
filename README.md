# Basic TCL Note Manager

a quick side-project to explore tcl/tk fundamentals and sqlite3 bindings by building a simple note manager.

## Features
- create, view, edit, and delete text notes  
- searchable list of note titles  
- data persisted in a local SQLite database  

## Requirements
- tcl/tk
- sqlite3  

## Installation
1. clone this repo  
   ```bash
   git clone https://github.com/felomousa/tcl-notes-app.git
   cd tcl-notes-app
   ```  
2. ensure tcl/tk and sqlite3 are installed  
   ```bash
   # macOS (Homebrew)
   brew install tcl-tk sqlite
   # Debian/Ubuntu
   sudo apt install tcl tk sqlite3 tcl-sqlite3
   ```  
3. make the script executable  
   ```bash
   chmod +x note_manager.tcl
   ```

## Usage
```bash
./note_manager.tcl
```

- click **New** to name and create a note  
- select a title from the list to load its body  
- edit text and click **Save**  
- click **Delete** to remove a note  
- use the search box to filter titles  

all notes are stored in `notes.db` in the project folder.

