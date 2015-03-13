echo === OTA update script ===
# Global configuration
setenv ota_done 0
setenv ota_abort 0
setenv ota_verbose 1

# Remove ota_abort_reason which is used to report error in case of failure
env delete ota_abort_reason

# Define some u-boot functions
# before running theses functions check for ota_abort var
# in case of failure theses functions set ota_abort and ota_abort_reason var
# the function verbosity is controlled by ota_verbose var

# function ota_conv_sizes
# Convert a bytes size to a block size
# input bytesize : size in bytes to convert
# input blksize : size of a block in bytes
# output numblk : converted size in blocks
setenv ota_conv_sizes 'setexpr num_blk $bytesize / $blksize ; setexpr mod_blk $bytesize % $blksize ; if itest $mod_blk > 0 ; then setexpr num_blk $num_blk + 1; fi;'

# function ota_mmc_write
# Write a memory buffer to mmc drive
# input floadaddr     : address of buffer to write
# input u_part_start : block start in mmc
# input num_blk      : number of block to write
setenv ota_mmc_write 'if itest $ota_verbose == 1 ; then echo "mmc write ${floadaddr} ${u_part_start} ${num_blk};"; fi; mmc write $floadaddr $u_part_start $num_blk; ret=$?; if itest $ret != 0 ; then setenv ota_abort_reason "mmc write ${floadaddr} ${u_part_start} ${num_blk} failed"; setenv ota_abort 1; fi;'

# function ota_load_image
# Load partition binary image from update partition to memory
# input  ota_drive      : ota drive name
# input  ota_image_name : filename of image to load
# input  floadaddr       : memory address destination
# output filesize       : size of image in bytes
setenv ota_load_image 'if itest $ota_verbose == 1 ; then echo "fatload ${ota_drive} ${floadaddr} ${ota_image_name};"; fi; fatload ${ota_drive} ${floadaddr} ${ota_image_name};ret=$?; if itest $ret != 0 ; then setenv ota_abort_reason "fatload ${ota_drive} ${floadaddr} ${ota_image_name} failed: ${ret}"; setenv ota_abort 1; fi;'

# function ota_compute_hash
# Compute Sha1 of a Loaded image in memory
# input  floadaddr : memory address destination
# input  filesize  : size of image in bytes
# output sha1_sum  : sha1 sum  of loaded file
setenv ota_compute_hash 'if itest $ota_verbose == 1 ; then echo "hash sha1 $floadaddr $filesize sha1_sum;"; fi; hash sha1 $floadaddr $filesize sha1_sum;ret=$?; if itest $ret != 0 ; then setenv ota_abort_reason "hash sha1 $floadaddr $filesize sha1_sum failed: ${ret}"; setenv ota_abort 1; fi;'

# function ota_test_image_and_partition_sizes
# Test if image fit partition
# input num_blk : image size in blocks
# input u_part_sz : partition size in blocks
setenv ota_test_image_and_partition_sizes 'if itest $num_blk > $u_part_sz ; then setenv ota_abort_reason "Partition ${u_part_lbl} too small for ${ota_image_name}"; setenv ota_abort 1; fi;'

# function ota_find_partition
# Find a partition by label
# input u_part_lbl : partition label
# output u_part_num : partition number
setenv ota_find_partition 'if itest $ota_verbose == 1 ; then echo "part find mmc 0 label:${u_part_lbl} u_part_num;"; fi; part find mmc 0 label:${u_part_lbl} u_part_num;ret=$?; if itest $ret != 0 ; then setenv ota_abort_reason "part find mmc 0 label:${u_part_lbl} u_part_num failed: ${ret}"; setenv ota_abort 1; fi;'

# function ota_get_partition_attributes
# Retrieve partition attribute
# input  u_part_num   : partition number
# output u_part_start : partition start block number
# output u_part_sz    : partition size in blocks
# output u_part_blksz : partition block size in bytes
setenv ota_get_partition_attributes 'if itest $ota_verbose == 1 ; then echo "part info mmc 0:${u_part_num} u_part_start u_part_sz u_part_blksz;"; fi; part info mmc 0:${u_part_num} u_part_start u_part_sz u_part_blksz;ret=$?; if itest $ret != 0 ; then setenv ota_abort_reason "part info mmc 0:${u_part_num} u_part_start u_part_sz u_part_blksz failed: ${ret}"; setenv ota_abort 1; fi;'

# function ota_exec_verbose_cmd
# Execute a command when verbosity is set
# input vb_cmd : contains code to run verbosily
setenv ota_exec_verbose_cmd 'if itest $ota_verbose == 1 ; then run vb_cmd ; fi;'


# function ota_cleans_script
# remove from environment all variables and functions in this script
setenv ota_cleans_script 'env delete -f sha1_sum sha1_sum_ref; env delete -f u_part_blksz u_part_lbl u_part_num u_part_start u_part_sz updt_part_num ota_drive; env delete -f mod_blk num_blk filesize bytesize blksize floadaddr vb_cmd; env delete -f floadaddr; env delete -f ota_conv_sizes ota_mmc_write ota_load_image ota_compute_hash; env delete -f ota_test_image_and_partition_sizes ota_find_partition ota_get_partition_attributes ota_exec_verbose_cmd ota_cleans_script;'

# handle two pass validation of script
if env exist ota_checked ; then if itest $ota_checked == 0; then echo "Ota previously failed retry"; fi; else setenv ota_checked 0; fi;
if itest $ota_checked == 0; then echo "Validating Ota package" ; else echo "Processing Ota update"; fi;

setenv floadaddr 0x6400000

# Find update partition on emmc drive
setenv u_part_lbl update;
run ota_find_partition ;
if itest $ota_abort == 1 ; then run ota_cleans_script; exit ; fi;

setenv ota_drive mmc 0:${u_part_num}
if itest $ota_verbose == 1 ; then echo "ota drive is $ota_drive"; fi

# Start update of edison_ifwi-dbg-dfu.bin on ifwi 1 and 2
setenv ota_image_name edison_ifwi-dbg-${hardware_id}-dfu.bin ;
# Tell user what's going on
echo " "
if itest $ota_checked == 1 ; then
echo "Update IFWI on boot0 and boot1 partitions";
else
echo "Validating ${ota_image_name} hash for boot0 and boot1 partitions";
fi;
echo " "

# Load binary image from update partition to memory
run ota_load_image;
if itest $ota_abort == 1 ; then run ota_cleans_script; exit ; fi;

if itest $ota_checked == 0 ; then
    # Select sha1_sum_ref according to corresponding hardware_id
    if itest.s ${hardware_id} == "00" ; then setenv sha1_sum_ref @@sha1_edison_ifwi-dbg-00-dfu.bin ; fi;
    if itest.s ${hardware_id} == "01" ; then setenv sha1_sum_ref @@sha1_edison_ifwi-dbg-01-dfu.bin ; fi;
    if itest.s ${hardware_id} == "02" ; then setenv sha1_sum_ref @@sha1_edison_ifwi-dbg-02-dfu.bin ; fi;
    if itest.s ${hardware_id} == "03" ; then setenv sha1_sum_ref @@sha1_edison_ifwi-dbg-03-dfu.bin ; fi;
    if itest.s ${hardware_id} == "04" ; then setenv sha1_sum_ref @@sha1_edison_ifwi-dbg-04-dfu.bin ; fi;
    if itest.s ${hardware_id} == "05" ; then setenv sha1_sum_ref @@sha1_edison_ifwi-dbg-05-dfu.bin ; fi;
    if itest.s ${hardware_id} == "06" ; then setenv sha1_sum_ref @@sha1_edison_ifwi-dbg-06-dfu.bin ; fi;

    # Verify data integrity
    run ota_compute_hash;
    if itest $ota_abort == 1 ; then run ota_cleans_script; exit ; fi;
    if itest.s $sha1_sum_ref != $sha1_sum ; then setenv ota_abort_reason "${ota_image_name} hash mismatch ($sha1_sum / $sha1_sum_ref)"; setenv ota_abort 1; fi;
    if itest $ota_abort == 1 ; then run ota_cleans_script; exit ; fi;
fi;

# Convert file size in byte to block, for ifwi used hardcoded values
setenv bytesize $filesize ;
setenv blksize 0x200 ;
run ota_conv_sizes ;

setenv vb_cmd 'echo "${ota_image_name} size is 0x$filesize bytes and 0x$num_blk block";'
run ota_exec_verbose_cmd ;

# Test if image fit partition
if itest $num_blk > 0x2000 ; then echo "${ota_image_name} Shrinked to fit partition ifwi "; setenv num_blk 2000 ; fi;

if itest $ota_checked == 1 ; then
# Set MMC ifwi partition to 1
    if itest $ota_verbose == 1 ; then echo "mmc dev 0 1;"; fi;
    mmc dev 0 1 ; ret=$?
    if itest $ret != 0 ; then setenv ota_abort_reason "mmc dev 0 1 failed: $ret"; setenv ota_abort 1; run ota_cleans_script; exit; fi;

    # Write image to partition
    setenv u_part_start 0x0;
    run ota_mmc_write;
    if itest $ota_abort == 1 ; then run ota_cleans_script; exit ; fi;

    # Set MMC ifwi partition to 2
    if itest $ota_verbose == 1 ; then echo "mmc dev 0 2;"; fi;
    mmc dev 0 2 ; ret=$?
    if itest $ret != 0 ; then setenv ota_abort_reason "mmc dev 0 2 failed: $ret"; setenv ota_abort 1; run ota_cleans_script; exit; fi;

    # Write image to partition
    setenv u_part_start 0x00;
    run ota_mmc_write;
    if itest $ota_abort == 1 ; then run ota_cleans_script; exit ; fi;

    # Set back MMC partition 0
    mmc dev 0 0 ;

    # Tell user about the status
    echo " "
    echo "Update of ${ota_image_name} to boot0 and boot1 partitions Done";
fi;

# Start update of u-boot-edison.bin on u-boot0
setenv ota_image_name u-boot-edison.bin
setenv u_part_lbl u-boot0
setenv sha1_sum_ref @@sha1_u-boot-edison.bin
# Tell user what's going on
echo " "
if itest $ota_checked == 1 ; then
echo "Update of ${ota_image_name} to ${u_part_lbl} partition";
else
echo "Validating ${ota_image_name} hash for ${u_part_lbl} partition";
fi;
echo " "

# Load partition binary image from update partition to memory
run ota_load_image;
if itest $ota_abort == 1 ; then run ota_cleans_script; exit ; fi;

# Find partition u-boot0
run ota_find_partition ;
if itest $ota_abort == 1 ; then run ota_cleans_script; exit ; fi;

# Retrieve partition attribute
run ota_get_partition_attributes ;
if itest $ota_abort == 1 ; then run ota_cleans_script; exit ; fi;

# Convert file size in byte to block
setenv bytesize $filesize ;
setenv blksize $u_part_blksz ;
run ota_conv_sizes ;

setenv vb_cmd 'echo "Partition ${u_part_lbl} Start:0x${u_part_start} Size:0x${u_part_sz} BlockSize:0x${u_part_blksz}"; echo "${ota_image_name} size is 0x${filesize} bytes and 0x${num_blk} block"; echo " ";'
run ota_exec_verbose_cmd ;

if itest $ota_checked == 0 ; then
    # Test if image fit partition
    run ota_test_image_and_partition_sizes ;
    if itest $ota_abort == 1 ; then run ota_cleans_script; exit ; fi;

    # Verify data integrity
    run ota_compute_hash;
    if itest $ota_abort == 1 ; then run ota_cleans_script; exit ; fi;
    if itest.s $sha1_sum_ref != $sha1_sum ; then setenv ota_abort_reason "${ota_image_name} hash mismatch ($sha1_sum / $sha1_sum_ref)"; setenv ota_abort 1; fi;
    if itest $ota_abort == 1 ; then run ota_cleans_script; exit ; fi;
else
    # Write image to partition
    run ota_mmc_write;
    if itest $ota_abort == 1 ; then run ota_cleans_script; exit ; fi;

    # Tell user about the status
    echo " "
    echo "Update of ${ota_image_name} to ${u_part_lbl} partition  Done";
fi;

if itest $ota_abort == 1 ; then run ota_cleans_script; exit ; fi;
# Start update of edison-image-edison.hddimg on boot
setenv ota_image_name edison-image-edison.hddimg
setenv u_part_lbl boot
setenv sha1_sum_ref @@sha1_edison-image-edison.hddimg

# Tell user what's going on
echo " "
if itest $ota_checked == 1 ; then
echo "Update of ${ota_image_name} to ${u_part_lbl} partition";
else
echo "Validating ${ota_image_name} hash for ${u_part_lbl} partition";
fi;

# Load partition binary image from update partition to memory
run ota_load_image ;
if itest $ota_abort == 1 ; then run ota_cleans_script; exit ; fi;

# Find partition boot
run ota_find_partition ;
if itest $ota_abort == 1 ; then run ota_cleans_script; exit ; fi;

# Retrieve partition attribute
run ota_get_partition_attributes ;
if itest $ota_abort == 1 ; then run ota_cleans_script; exit ; fi;

# Convert file size in byte to block
setenv bytesize $filesize ;
setenv blksize $u_part_blksz ;
run ota_conv_sizes ;

setenv vb_cmd 'echo "Partition ${u_part_lbl} Start:0x${u_part_start} Size:0x${u_part_sz} BlockSize:0x${u_part_blksz}"; echo "${ota_image_name} size is 0x${filesize} bytes and 0x${num_blk} block"; echo " ";'
run ota_exec_verbose_cmd ;

if itest $ota_checked == 0 ; then
    # Test if image fit partition
    run ota_test_image_and_partition_sizes ;
    if itest $ota_abort == 1 ; then run ota_cleans_script; exit ; fi;

    # Verify data integrity
    run ota_compute_hash;
    if itest $ota_abort == 1 ; then run ota_cleans_script; exit ; fi;
    if itest.s $sha1_sum_ref != $sha1_sum ; then setenv ota_abort_reason "${ota_image_name} hash mismatch ($sha1_sum / $sha1_sum_ref)"; setenv ota_abort 1; fi;
    if itest $ota_abort == 1 ; then run ota_cleans_script; exit ; fi;
else
    # Write image to partition
    run ota_mmc_write;
    if itest $ota_abort == 1 ; then run ota_cleans_script; exit ; fi;

    # Tell user about the status
    echo " "
    echo "Update of ${ota_image_name} to ${u_part_lbl} partition  Done";
fi;

# Start update of edison-image-edison.ext4 on rootfs
setenv ota_image_name edison-image-edison.ext4
setenv u_part_lbl rootfs
setenv sha1_sum_ref @@sha1_edison-image-edison.ext4

# Tell user what's going on
echo " "
if itest $ota_checked == 1 ; then
echo "Update of ${ota_image_name} to ${u_part_lbl} partition";
else
echo "Validating ${ota_image_name} hash for ${u_part_lbl} partition";
fi;
echo " "

# Load partition binary image from update partition to memory
run ota_load_image;
if itest $ota_abort == 1 ; then run ota_cleans_script; exit ; fi;

# Find partition rootfs
run ota_find_partition ;
if itest $ota_abort == 1 ; then run ota_cleans_script; exit ; fi;

# Retrieve partition attribute
run ota_get_partition_attributes ;
if itest $ota_abort == 1 ; then run ota_cleans_script; exit ; fi;

# Convert file size in byte to block
setenv bytesize $filesize ;
setenv blksize $u_part_blksz ;
run ota_conv_sizes ;

setenv vb_cmd 'echo "Partition ${u_part_lbl} Start:0x${u_part_start} Size:0x${u_part_sz} BlockSize:0x${u_part_blksz}"; echo "${ota_image_name} size is 0x${filesize} bytes and 0x${num_blk} block"; echo " ";'
run ota_exec_verbose_cmd ;


if itest $ota_checked == 0; then
    # Test if image fit partition
    run ota_test_image_and_partition_sizes ;
    if itest $ota_abort == 1 ; then run ota_cleans_script; exit ; fi;

    # Verify data integrity
    run ota_compute_hash;
    if itest $ota_abort == 1 ; then run ota_cleans_script; exit ; fi;
    if itest.s $sha1_sum_ref != $sha1_sum ; then setenv ota_abort_reason "$ota_image_name bad hash $sha1_sum != $sha1_sum_ref"; setenv ota_abort 1; fi;
    if itest $ota_abort == 1 ; then run ota_cleans_script; exit ; fi;
else
    # Write image to partition
    run ota_mmc_write;
    if itest $ota_abort == 1 ; then run ota_cleans_script; exit ; fi;

    # Tell user about the status
    echo " "
    echo "Update of ${ota_image_name} to ${u_part_lbl} partition  Done";
fi;

run ota_cleans_script;

echo " "
if itest $ota_checked == 0; then
    echo "Ota Pakage validated going to process it";
    setenv ota_checked 1;
    source $ota_script_addr;
else
    # Overall sumup and end of update cycle
    echo " "
    echo "Ota Success going to reboot";
    setenv ota_done 1 ;
    env delete -f ota_checked;
    setenv bootargs_target ota-update
    saveenv
    exit;
fi;
