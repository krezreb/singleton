### singleton

easily run bash scripts in singleton mode, e.g.: only one instance can be running on the system at a time.

Uses atomic file locks, so there's no race conditions

Installation

`sudo make install` 

Installs in /usr/bin

Usage

`singleton LOCKNAME PROGRAM`

Can also be used in your own scripts

```
#!/bin/env bash

$(singleton source) # gives you lock_try and lock_release functions
if [[ lock_try LOCKNAME ]] ; then
    # do stuff here
    lock_release
else
    # lock failed
fi
```

Examples:

Long running rsync command whose lock is called backup

```
singleton backup rsync -arv a b
```





