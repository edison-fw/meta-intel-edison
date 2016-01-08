#! /bin/sh

file_sketch=/sketch/sketch.elf
file_sketch_old=/sketch/sketch.elf.old

# Check file "sketch.elf" and replace it when detecting it has become zero size
if [ ! -s $file_sketch ] && [ -e $file_sketch ] ; then
        rm $file_sketch 2>/dev/null
        echo "Delete the zero-sized sketch.elf"
        if [ -s $file_sketch_old ] ; then
                cp $file_sketch_old $file_sketch
                echo "Correct the corrupted sketch.elf with sketch.elf.old"
        fi
fi

# Check file "sketch.elf.old" and remove it when detecting it has become zero size
if [ ! -s $file_sketch_old ] && [ -e $file_sketch_old ] ; then
        rm $file_sketch_old 2>/dev/null
        echo "Delete the zero-sized sketch.elf.old"
fi

