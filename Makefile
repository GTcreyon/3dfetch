AUTHORS="yyualice & daedreth"
CIA_DEPENDENCIES=lpp-3ds.elf bin/romfs.bin bin/banner.bnr bin/3dfetch.smdh 3dfetch.rsf

bin/3dfetch.cia: ${CIA_DEPENDENCIES}
	makerom -f cia -o $@ -DAPP_ENCRYPTED=false -rsf 3dfetch.rsf -target t -exefslogo -elf lpp-3ds.elf -icon bin/3dfetch.smdh -banner bin/banner.bnr -romfs bin/romfs.bin

# This one is for debugging purposes, some functionality is broken unless using a CIA
.PHONY: 3dsx
3dsx: bin/3dfetch.3dsx
	@[ "${3DS_ADDRESS}" ] || ( echo "3DS_ADDRESS is not set. It should be the IPv4 address of your 3DS as shown in HBL."; exit 1 )
	3dslink $< -a ${3DS_ADDRESS}
	
.PHONY: cia
cia: bin/3dfetch.cia
	$(info **********  cia file built **********)

bin/3dfetch.3dsx: bin/3dfetch.smdh
	3dsxtool lpp-3ds.elf $@ --romfs=romfs/ --smdh=$<

bin/romfs.bin: lpp-3ds.elf
	3dstool -cvtf romfs $@ --romfs-dir romfs/

bin/banner.bnr: bin/romfs.bin banner.png jingle.wav
	bannertool makebanner -i banner.png -a jingle.wav -o $@

bin/3dfetch.smdh: bin/banner.bnr icon.png
	bannertool makesmdh -s "3dfetch" -l "3dfetch" -p ${AUTHORS} -i icon.png -o $@

.PHONY: clean
clean:
	rm -rf bin
	rm -rf 3ds
