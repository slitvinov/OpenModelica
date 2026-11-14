set -e
omc s.mos
gcc -O2 -I om/include/omc/c/fmi -o run run.c -ldl
for n in 1 10000 50000; do for k in No In; do
	m=$k$n
	rm -rf $m && mkdir $m && (cd $m && unzip -q ../$m.fmu)
	g=$(grep -o 'guid="[^"]*"' $m/modelDescription.xml | cut -d'"' -f2)
	printf '%-8s ' $m
	./run $m/binaries/linux64/$m.so "$g" "file://$PWD/$m/resources" 20000
done; done
