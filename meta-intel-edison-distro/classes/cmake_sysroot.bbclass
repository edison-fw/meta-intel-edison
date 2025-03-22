# class to keep cmake files staged to sysroot for modifications/checks

# filename for the file containg full names of all cmakefiles staged
CMAKEINSTALLED = "${WORKDIR}/staged_cmake_files"

# 1. remove tmp file from last build
python do_populate_sysroot:prepend() {
    tmpfile = d.getVar('CMAKEINSTALLED')
    if os.path.isfile(tmpfile):
        os.remove(tmpfile)
}

# 2. keep cmake files staged to sysroot
sysroot_stage_dir:append() {
    # avoid doubles causing double replacement
    for file in `find $dest -name '*.cmake'`; do
        if ! grep -q "$file" ${CMAKEINSTALLED} ; then
            echo "$file" >> ${CMAKEINSTALLED}
        fi
    done
}


