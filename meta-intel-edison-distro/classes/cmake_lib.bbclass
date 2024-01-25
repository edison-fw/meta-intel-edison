# This class helps to align paths for cmake files in build sysroot while
# keeping proper paths for target packages/rootfs
#
# Alignment is controlled by:
#
#   CMAKE_ALIGN_SYSROOT[<unique-id>] = "<dir>, <search>, <replace>"
#
#   <unique-id>:
#      string value of your choice e.g. "1", "2"...
#      !!COMMON PITFALL!!: Copy & Paste CMAKE_ALIGN_SYSROOT lines without updating unique-id ->
#      not all lines are evaluated!!
#
#   <dir>:
#      cmake configuration files are usually installed as
#
#      1. ${libdir}/cmake/<CMakePackageName>/*.cmake
#      or
#      2. ${datadir}/cmake/<CMakePackageName>/*.cmake
#
#      'dir' can be any matching part of 1. and 2. but suggestion is to use
#      is <CMakePackageName>
#
#   <search>/<replace>:
#      cmake configuration files are scanned and the resulting string found in 'search'
#      is replaced by resulting string of 'replace'. To create a resulting string currently
#      6 command-line like options are available (see parseparam below):
#
#        -f<file-in-WORKDIR>:
#          Resulting string is taken from the file <file-in-WORKDIR>. This option should be
#          choosen for longer strings or stings containg ','.
#        -F<file-in-WORKDIR>:
#          same as -f but bitbake variables are expanded e.g '${libdir}' -> '/usr/lib'
#        -s<string>
#          Resulting string is <string>
#        -S<string>
#          same as -s but bitbake variables are expanded e.g '${libdir}' -> '/usr/lib'
#        -c<shell-command>
#          Resulting string is created by the shell command found in <shell-command>
#        -C<shell-command>
#          same as -c but bitbake variables are expanded BEFORE executing shell command
#
#
# Native overriding:
#
#   CMAKE_ALIGN_SYSROOT:class-native[<unique-id>] = "<dir>, <search>, <replace>"
#
# Native extended recipe -> no native alignement:
#
#   CMAKE_ALIGN_SYSROOT:class-native[<unique-id>] = "ignore"
#   CMAKE_ALIGN_SYSROOT[<unique-id>] = "<dir>, <search>, <replace>"
#
# Native extended recipe -> no cross alignement:
#
#   CMAKE_ALIGN_SYSROOT:class-native[<unique-id>] = "<dir>, <search>, <replace>"
#   CMAKE_ALIGN_SYSROOT[<unique-id>] = "ignore"
#

inherit cmake_sysroot

SSTATE_SYSROOT = "${STAGING_DIR}-components/${PACKAGE_ARCH}/${PN}"

# global helper to get CMAKE_ALIGN_SYSROOT array
def get_align_flags(d):
    ret = {}
    if bb.data.inherits_class('native', d):
        ret = d.getVarFlags("CMAKE_ALIGN_SYSROOT:class-native") or {}
    if ret == {}:
        ret = d.getVarFlags("CMAKE_ALIGN_SYSROOT") or {}
    return ret

# global helper to check CMAKE_ALIGN_SYSROOT array contains 'ignore'
def get_flags_ignore(flags):
    if flags and list(flags.values()).count('ignore') > 0:
        return True
    return False


# 1. basic checks for CMAKE_ALIGN_SYSROOT
python () {
    cmakehideflags = get_align_flags(d)
    if get_flags_ignore(cmakehideflags):
        return

    pn = d.getVar('PN')
    if cmakehideflags:
        for flag, flagval in sorted(cmakehideflags.items()):
            items = flagval.split(",")
            num = len(items)
            if num != 3:
                bb.fatal('CMAKE_ALIGN_SYSROOT[%s] requires 3 parameters (dir, search, replace) in %s' % (flag, pn))
    else:
        bb.fatal('The recipe %s inherits cmake_lib but does not set CMAKE_ALIGN_SYSROOT' % pn)
}

# 2. 3. in cmake_sysroot

# 4. Handle CMAKE_ALIGN_SYSROOT
python do_populate_sysroot:append() {
    pn = d.getVar('PN')

    # parse single parameter in CMAKE_ALIGN_SYSROOT[..] and return array of line strings extracted
    def parseparam(param, flag):
        param = param.strip()
        if len(param) > 2:
            cmd = param[0:2]
            cmdparam = param[2:]

            # handle file in WORKDIR
            if cmd == '-f' or cmd == '-F':
                filename = "%s/%s" % (d.getVar('WORKDIR'), cmdparam)
                if os.path.isfile(filename):
                    fd = open(filename, 'r')
                    str = fd.read()
                    fd.close()
                    if cmd == '-f':
                        return str
                    else:
                        return d.expand(str)
                else:
                    bb.fatal("file '%s' referenced in %s could not be found" % (filename, pn))

            # handle string
            elif cmd == '-s':
                return cmdparam
            elif cmd == '-S':
                return d.expand(cmdparam)

            # handle shell command
            elif cmd == '-c' or cmd == '-C':
                # pre expand for shell
                if cmd == '-C':
                    cmdparam = d.expand(cmdparam)
                pipe = os.popen(cmdparam)
                str = pipe.read()
                pipe.close()
                return str
            else:
                bb.fatal("CMAKE_ALIGN_SYSROOT[%s] contains an invalid parameter '%s%s' in %s" % (flag, cmd, cmdparam, pn))
        else:
            bb.fatal("Parameter %s is too short for CMAKE_ALIGN_SYSROOT[%s] in %s" % (param, flag, pn))

    cmakehideflags = get_align_flags(d)
    if get_flags_ignore(cmakehideflags):
        return

    # check if cmake files were installed to sysroot
    tmpfile = d.getVar('CMAKEINSTALLED')
    if (not os.path.isfile(tmpfile)) or os.path.getsize(tmpfile) == 0:
        bb.warn("There were no cmake files installed by %s" % pn)
    else:
        # parse CMAKE_ALIGN_SYSROOT[..]
        for flag, flagval in sorted(cmakehideflags.items()):
            items = flagval.split(",")

            # 1. cmake-subdirectory in sysroot
            cmakedir = d.expand(items[0])
            if len(cmakedir) == 0:
                bb.fatal('Directory in CMAKE_ALIGN_SYSROOT[%s] must not be empty in %s' % (flag, pn))
            # check if this directory is created by us
            pipe = os.popen('grep %s %s' % (cmakedir, d.getVar('CMAKEINSTALLED')))
            matching_files = pipe.readlines()
            pipe.close()
            if len(matching_files) == 0:
                bb.warn("No matching cmake file found for directory '%s' set by CMAKE_ALIGN_SYSROOT[%s] in %s" % (cmakedir, flag, pn))

            # 2. search
            search = parseparam(items[1], flag)
            if len(search) == 0:
                bb.warn("Search string must not be empty - see CMAKE_ALIGN_SYSROOT[%s] in %s" % (flag, pn))

            # 3. replace
            replace = parseparam(items[2], flag)

            # TBD: further checks?
            #bb.warn("cmakedir: '%s' search: '%s' replace: '%s'" % (cmakedir, search, replace))

            # Now do the replacements
            if len(matching_files) > 0:
                replacement_performed = False
                for filename in matching_files:
                    filename = filename.replace('\n','')
                    f = open(filename, 'r')
                    cmakestr = f.read()
                    f.close()
                    cmakestr_new = cmakestr.replace(search, replace)
                    if cmakestr_new != cmakestr:
                        replacement_performed = True
                        # Undo double replacement possibly caused by absolute paths from other libraries
                        # (e.g fixed at do_install)
                        doublereplace = replace.replace(search, replace)
                        cmakestr_new = cmakestr_new.replace(doublereplace, replace)
                        # do write only if necessary
                        if cmakestr_new != cmakestr:
                            # we delete the old file to unbreak link to image-path path causing
                            # package polution with sysroot paths
                            os.remove(filename)
                            f = open(filename, 'w')
                            f.write(cmakestr_new)
                            f.close()
                if not replacement_performed:
                    bb.warn("No cmake replacements performed in %s for CMAKE_ALIGN_SYSROOT[%s]" % (pn, flag))
}

do_populate_sysroot[vardeps] += "CMAKE_ALIGN_SYSROOT CMAKE_ALIGN_SYSROOT:class-native"

# change of CMAKE_ALIGN_SYSROOT causes configure rerun which currently seems
# the only way to force a rebuild at change of CMAKE_ALIGN_SYSROOT for recipes
# depending on this recipe

sysroot_cleansstate[vardeps] += "CMAKE_ALIGN_SYSROOT CMAKE_ALIGN_SYSROOT:class-native"

