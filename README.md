# singleton

Easily run scripts in singleton mode, e.g.: only one instance can be running on the system at a time.  Uses atomic file locks, so there's no race conditions.

## Installation

Once you've cloned this repo

`sudo make install` 

Installs in /usr/bin

Or install without cloning this repo using curl one liner

```
sudo wget  https://raw.githubusercontent.com/krezreb/singleton/master/singleton.sh -o /usr/bin/singleton \
&& sudo chmod +x /usr/bin/singleton
```

## Usage

`singleton LOCKNAME PROGRAM ARGS...`

Can also be used in your own scripts

```
#!/bin/env bash

$(singleton source) # gives you lock_try and lock_release functions
if lock_try LOCKNAME ; then
    # do stuff here
    lock_release
else
    # lock failed
fi
```

Examples:

Using singleton can be as easy as prepending "singleton LOCKNAME" to any command, here is a long running rsync command whose lock is called "backup"

```
singleton backup rsync -arv a b
```


## Running Tests

`make test` 

Runs a bunch of parallel test programs, only one winner of which should get the lock. 