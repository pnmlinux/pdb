# pdb 1 2022-07-23 "1.0.0" 

## NAME
pdb \- key / value based data base management tool using cpio.

## SYNOPSIS
pdb [{-n|-s|-r|-g}] [FILE]

## DESCRIPTION
**pdb** key / value based raw data storage tool uses cpio.
It is a library written in bash, but it is shell friendly
and offers the opportunity to run the file directly.

## OPTIONS
you can source the library or use directly in the shell.

### -n, --new
this parameter creates an empty cpoi archive but the file of type
may change during use. In this case, you are kindly requested to contact us as an issue.

**as function**:
```
pdb:new "example.db"
```

**in shell**:
```
bash pdb.sh --new "example.db"
```

### -s, --set
with the set, you can create a key and write any value inside of keys you can use,
you cannot use special characters as key names.

**as function**:
```
pdb:set "example.db" "test" "deneme123"
```

**in shell**:
```
bash pdb.sh --set "example.db" "test" "deneme123"
```

### -r, --rem
rem means 'remove' so you can remove that the keys.

**as function**:
```
pdb:rem "example.db" "test"
```

**in shell**:
```
bash pdb.sh --rem "example.sh" "test"
```

### -g, --get
with the get you can call the value of keys.

**as function**:
```
pdb:get "example.db" "test"
```

**in shell**:
```
bash pdb.sh --get "example.sh" "test"
```

## BUGS
No known bugs.

## COPYRIGHT
License GPLv3+: GNU GPL version 3 or later [http://gnu.org/licenses/gpl.html](http://gnu.org/licenses/gpl.html).
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.

## AUTHOR
Written by lazypwny751 for pnm linux.

source: **https://github.com/pnmlinux/pdb**

## SEE ALSO
[cpio 1](man)