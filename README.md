# pdb - pnm database tool

**pdb** key / value based raw data storage tool and library uses cpio.
It is a library written in bash, but it is shell friendly
and offers the opportunity to run the file directly.

## INSTALLATION
after the installation the files going to be in the $root/usr/local/lib/bash5 , but it doesn't touch the documents.

```
git clone "https://github.com/pnmlinux/pdb.git" && cd "pdb"
bash configure.sh
make install
```

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
## REQUIREMENTS

- [libarchive](https://github.com/libarchive/libarchive)
- [coreutils](https://github.com/coreutils/coreutils)
- [findutils](https://git.savannah.gnu.org/git/findutils)

## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

## License
[GPL3](https://choosealicense.com/licenses/gpl-3.0/)
