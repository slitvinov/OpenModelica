set -e
omc s.mos
gcc -O2 -I om/include/omc/c/fmi -o run run.c -ldl
for m in M1 M10000 M50000; do
	rm -rf $m && mkdir $m && (cd $m && unzip -q ../$m.fmu)
	g=$(grep -o 'guid="[^"]*"' $m/modelDescription.xml | cut -d'"' -f2)
	printf '%s FMU: ' $m
	./run $m/binaries/linux64/$m.so "$g" "file://$PWD/$m/resources" 20000
done
