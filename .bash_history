ls
paccache -r
pacdiff
ls
pacman -Suy
paccache -r
ls
pacman -S mingw-w64-x86_64-iverilog
pacman -S mingw-w64-x86_64-yosys
ls
cat MyInverter.v
vi MyInverter.v
ls
pacman -S vim
ls
vim MyInverter.v
ls
echo "module MyInverter(input a, output y);" > MyInverter.v
echo "assign y= ~a;" >> MyInverter.v
echo "endmodule" >> MyInverter.v
cat MyInverter.v
ls
iverilog -v
pacman -S mingw-w64-x86_64-iverilog
ls
pacman -S nano
nano testbench.v
ls
ls
wsl --install
ls
ls
history
ll
acal
cal
date
google
server
brew install renode
ls
yosys
yosys
yosys -p "read_verilog newproject1.v; synth; stat"
yosys
packman -Syc
pacman -Syu
pacman -S --needed base-devel mingw-w64-ucrt-x86_64-toolchain mingw-w64-ucrt-x86_64-iverilog mingw-w64-ucrt-x86_64-gtkwave
pacman -S --needed base-devel mingw-w64-ucrt-x86_64-toolchain mingw-w64-ucrt-x86_64-iverilog mingw-w64-ucrt-x86_64-gtkwave
bash.exe
pacman.exe
mintty.exe
msys2.exe
ls
pacman -Syu
ls
Windows Settings → Apps → Installed Apps → MSYS2 → Uninstall
C:\msys64
Installed Apps
MSYS2
appwiz.cpl
C:\msys64
ls
iverilog -V
gtkwave --version
mkdir axi_fir
cd axi_fir
notepad fir_axis_core.v
notepad tb_fir_axis_core.v
ls
iverilog -o fir_sim tb_fir_axis_core.v fir_axis_core.v
vvp fir_sim
gtkwave dump.vcd
ls
mkdir signed_arithmetic_project
cd signed_arithmetic_project
mkdir rtl tb sim docs
ls
notepad rtl/signed_arithmetic.v
notepad tb/tb_signed_arithmetic.v
iverilog -o sim/signed_sim tb/tb_signed_arithmetic.v rtl/signed_arithmetic.v
vvp sim/signed_sim
gtkwave sim/signed_arithmetic.vcd
ls
ll
yosys
mkdir yosys_mux_project
cd yosys_mux_project
notepad mux2to1.v
exit
ls
cd ~/axi_lite_register_block
ls
ls rtl
ls tb
iverilog -o sim/axi_sim tb/tb_axi_lite_reg_block.v rtl/axi_lite_reg_block.v
vvp sim/axi_sim
gtkwave sim/axi_lite_reg_block.vcd
cp ~/axi_lite_register_block/rtl/axi_lite_reg_block.v /c/Users/"shivanshu yadav"/Desktop/
cd..
cd 
mkdir -p /c/SP_Data/axi_lite_register_block/rtl
cp ~/axi_lite_register_block/rtl/axi_lite_reg_block.v /c/SP_Data/axi_lite_register_block/rtl/
ls /c/SP_Data/axi_lite_register_block/rtl
mkdir -p /c/SP_Data/axi_lite_register_block/rtl
cp ~/axi_lite_register_block/rtl/axi_lite_reg_block.v /c/SP_Data/axi_lite_register_block/rtl/
ls /c/SP_Data/axi_lite_register_block/rtl
mkdir -p /c/SP_Data/axi_lite_register_block/constraints
notepad /c/SP_Data/axi_lite_register_block/constraints/axi_lite_reg_block.xdc
notepad /c/SP_Data/axi_lite_register_block/constraints/axi_lite_reg_block.xdc
notepad /c/SP_Data/axi_lite_register_block/constraints/axi_lite_reg_block.xdc
mkdir -p /c/SP_Data/hls_vector_add/src
mkdir -p /c/SP_Data/hls_vector_add/tb
mkdir -p /c/SP_Data/hls_vector_add/docs
cd /c/SP_Data/hls_vector_add
ls
notepad /c/SP_Data/hls_vector_add/src/vector_add.h
notepad /c/SP_Data/hls_vector_add/src/vector_add.cpp
notepad /c/SP_Data/hls_vector_add/tb/tb_vector_add.cpp
cd /d C:\SP_Data
C:/SP_Data/DHRUV64_SHIV_R
cd /c/SP_Data/DHRUV64_SHIV_R
cd /c/SP_Data
ls
cd /c/SP_Data/DHRUV64_SHIV_RF
ls
find rtl tb constraints docs -type f
notepad rtl/dhruv64_alu.sv
notepad tb/tb_dhruv64_alu.sv
notepad rtl/dhruv64_core_top.sv
cd /c/SP_Data/DHRUV64_SHIV_RF
sed -n '1,80p' rtl/shiv_register_file_64.sv
notepad rtl/shiv_register_file_64.sv
notepad C:/SP_Data/DHRUV64_SHIV_RF/rtl/shiv_register_file_64.sv
notepad C:/SP_Data/DHRUV64_SHIV_RF/rtl/dhruv64_alu.sv
notepad C:/SP_Data/DHRUV64_SHIV_RF/rtl/dhruv64_core_top.sv
mkdir -p /c/SP_Data/DHRUV64_CORE_V2_TEST
cd..
cd
mkdir -p /c/SP_Data/DHRUV64_CORE_V2_TEST
cd /c/SP_Data/DHRUV64_CORE_V2_TEST
notepad dhruv64_core_v2_60_features_single_file.sv
iverilog -g2012 -o dhruv64_test.vvp dhruv64_core_v2_60_features_single_file.sv
vvp dhruv64_test.vvp
cd /c/SP_Data/DHRUV64_CORE_V2_TEST
ls
iverilog -g2012 -o dhruv64_test.vvp dhruv64_core_v2_60_features_single_file.sv
vvp dhruv64_test.vvp
cd /c/SP_Data/DHRUV64_CORE_V2_TEST
notepad dhruv64_fpga_top.sv
cd /c/SP_Data/DHRUV64_CORE_V2_TEST
ls
notepad dhruv64_core_v2.xdc
cd /c/SP_Data/DHRUV64_CORE_V2_TEST
notepad dhruv64_fpga_top.sv
cd /c/SP_Data/DHRUV64_CORE_V2_TEST
notepad dhruv64_fpga_top.sv
cd /c/SP_Data/DHRUV64_CORE_V2_TEST
notepad dhruv64_fpga_top.sv
notepad dhruv64_fpga_top.sv
cd /c/SP_Data/DHRUV64_CORE_V2_TEST
notepad dhruv64_fpga_top.sv
cd /c/SP_Data/DHRUV64_CORE_V2_TEST
ls
mkdir -p docs
notepad docs/PROJECT_STATUS.md
cd /c/SP_Data/DHRUV64_CORE_V2_TEST
mkdir -p backup_final
cp dhruv64_core_v2_60_features_single_file.sv backup_final/
cp dhruv64_fpga_top.sv backup_final/
cp dhruv64_core_v2.xdc backup_final/ 2>/dev/null
powershell Compress-Archive -Path backup_final/* -DestinationPath DHRUV64_CORE_V2_FINAL_BACKUP.zip -Force
powershell -Command "Compress-Archive -Path 'backup_final/*' -DestinationPath 'DHRUV64_CORE_V2_FINAL_BACKUP.zip' -Force"
ls
powershell -Command "Get-ChildItem 'DHRUV64_CORE_V2_FINAL_BACKUP.zip'"
ls -lh DHRUV64_CORE_V2_FINAL_BACKUP.zip
powershell -Command "Expand-Archive -Path 'DHRUV64_CORE_V2_FINAL_BACKUP.zip' -DestinationPath 'zip_check' -Force"
ls zip_check
cp docs/PROJECT_STATUS.md backup_final/
powershell -Command "Compress-Archive -Path 'backup_final/*' -DestinationPath 'DHRUV64_CORE_V2_FINAL_BACKUP.zip' -Force"
rm -rf zip_check
powershell -Command "Expand-Archive -Path 'DHRUV64_CORE_V2_FINAL_BACKUP.zip' -DestinationPath 'zip_check' -Force"
ls zip_check
rm -rf zip_check
cd /c/SP_Data/DHRUV64_CORE_V2_TEST
iverilog -g2012 -s tb_dhruv64_feature_verify -o feature_verify.vvp dhruv64_core_v2_60_features_single_file.sv tb_dhruv64_feature_verify.sv
iverilog -g2012 -s tb_dhruv64_feature_verify -o feature_verify.vvp dhruv64_core_v2_60_features_single_file.sv tb_dhruv64_feature_verify.sv
notepad tb_dhruv64_feature_verify.sv
ls
iverilog -g2012 -s tb_dhruv64_feature_verify -o feature_verify.vvp dhruv64_core_v2_60_features_single_file.sv tb_dhruv64_feature_verify.sv
vvp feature_verify.vvp
ls tb_dhruv64_feature_verify_v2.sv
cd /c/SP_Data/DHRUV64_CORE_V2_TEST
ls tb_dhruv64_feature_verify_v2.sv
find "/c/Users/shivanshu yadav/Downloads" -name "tb_dhruv64_feature_verify_v2*.sv"
cp "/c/Users/shivanshu yadav/Downloads/tb_dhruv64_feature_verify_v2.sv" /c/SP_Data/DHRUV64_CORE_V2_TEST/
cd /c/SP_Data/DHRUV64_CORE_V2_TEST
notepad tb_dhruv64_feature_verify_v2.sv
