#!/bin/bash
# Compile
rm -rf Executables-Massifs-Reports/

val=0
declare -A files

echo "====FILES===="
for c_file in *.c; do
    echo "${val}: ${c_file}"
    files[${val}]=${c_file}
    (( val+=1 ))
done

echo ""

input=999
while [ ${input} -lt 0 ] || [ ${input} -ge $val ]; do
    echo "Input a correct index value ( < ${val})"
    read -r input
done

mkdir -p Executables-Massifs-Reports/Executables
mkdir -p Executables-Massifs-Reports/Massifs
mkdir -p Executables-Massifs-Reports/Reports


echo "Compiling ${files[${input}]}"

echo "FILE ${files[${input}]}"

cp ${files[${input}]} ./Executables-Massifs-Reports

function compile_c {
   for i in $(seq 0 3); do
    gcc ./Executables-Massifs-Reports/*.c -O"${i}" -o "./Executables-Massifs-Reports/Executables/O${i}"
   done
}


function compile_massifs {
    echo ${executable}
    cd ./Executables-Massifs-Reports/Massifs/
    for executable in ../Executables/*; do
        valgrind --tool=massif ${executable}
     done

}
sequence=0

function print_massifs {
     cd ../Reports/
     for massif in $(echo ../Massifs/* | sort); do
         ms_print ${massif} > "massif_report_0${sequence}.txt"
         (( sequence += 1 ))
     done

 }


compile_c
compile_massifs
print_massifs
