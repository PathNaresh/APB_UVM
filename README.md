Create 3 sub directories like rtl, tb & sim.

Create compile_file.sv file & contains list of all files to be compiled, which is in parallel with 3 sub directories.

Design file is in the rtl sub directory.

Rest all files are in the tb sub directory.

Inside the sim sub directory create the makefile - which contains the commands to execute. For instance to compilation use 'make compile' & for simulation use 'make simulate' etc.
can check for those other commands in the makefile. Note - to run these commands go to the sim sub directory & should run every inside it.

I used tool questasim/2022.4 version [module load mentor/questasim/2022.4]

after simulation inside the sim sub directory - transacript, vsim.wlf, dump.vcd & work will be generated.

check this following path for tool uasge & for help 
https://drive.google.com/drive/folders/1bF-ltPZ1pHuKDRo0WZL-aM9aG7kh5V9a
