; восстановление исходного MYTHLAND.TRD средствами sjasmplus
; запускать из корня проекта, см. README.md
                device ZXSPECTRUM48
                include "Includes/Include.inc"
VerifyOriginal  EQU 1
                emptytrd "MYTHLAND.trd", "MYTHLAND"

                ; создание структуры диска с сохранением служебных данных и удалённых файлов
                lua pass3
                    dofile("Tools/pack.lua")
                    begin_image()
                endlua

                ; компиляция блока CTPB и размещение по исходному смещению диска
                include "Source/Loader/Basic.asm"
                lua pass3
                    store_block(23867, 256, 4608, nil)
                endlua

                ; компиляция блока CTPL и размещение по исходному смещению диска
                include "Source/Loader/Sectors.asm"
                lua pass3
                    store_block(32768, 256, 4864, "Tools/Disasm/Disk/Keys/CTPL.xor")
                endlua

                ; компиляция блока CTPM и размещение по исходному смещению диска
                include "Source/Loader/Menu.asm"
                lua pass3
                    store_block(24945, 5632, 5120, "Tools/Disasm/Disk/Keys/CTPM.xor")
                endlua

                ; компиляция блока CTPA и размещение по исходному смещению диска
                include "Source/Loader/Music.asm"
                lua pass3
                    store_block(57344, 3072, 10752, "Tools/Disasm/Disk/Keys/CTPA.xor")
                endlua

                ; компиляция блока S00 и размещение по исходному смещению диска
                include "Source/Files/00_boot.asm"
                lua pass3
                    store_block(23867, 31, 4096, nil)
                endlua

                ; компиляция блока S01 и размещение по исходному смещению диска
                include "Source/Files/01_Credits.asm"
                lua pass3
                    store_block(23867, 249, 4352, nil)
                endlua

                ; компиляция блока S04 и размещение по исходному смещению диска
                include "Source/Files/04_BL3.asm"
                lua pass3
                    store_block(24905, 7147, 14336, "Tools/Disasm/Disk/Keys/S04.xor")
                endlua

                ; компиляция блока S05 и размещение по исходному смещению диска
                include "Source/Files/05_RAMDRIVE.asm"
                lua pass3
                    store_block(32052, 588, 21504, nil)
                endlua

                ; компиляция блока S06 и размещение по исходному смещению диска
                include "Source/Files/06_PRES.asm"
                lua pass3
                    store_block(49152, 11295, 22272, nil)
                endlua

                ; компиляция блока S07 и размещение по исходному смещению диска
                include "Source/Files/07_DATA2.asm"
                lua pass3
                    store_block(32768, 7975, 33792, nil)
                endlua

                ; компиляция блока S08 и размещение по исходному смещению диска
                include "Source/Files/08_HERIMG.asm"
                lua pass3
                    store_block(32051, 22988, 41984, nil)
                endlua

                ; компиляция блока S09 и размещение по исходному смещению диска
                include "Source/Files/09_HERTXT.asm"
                lua pass3
                    store_block(32768, 2124, 65024, nil)
                endlua

                ; компиляция блока S10 и размещение по исходному смещению диска
                include "Source/Files/10_head_co.asm"
                lua pass3
                    store_block(24926, 19766, 67328, nil)
                endlua

                ; компиляция блока S11 и размещение по исходному смещению диска
                include "Source/Files/11_PERSON1.asm"
                lua pass3
                    store_block(32768, 245, 87296, nil)
                endlua

                ; компиляция блока S12 и размещение по исходному смещению диска
                include "Source/Files/12_PERSON2.asm"
                lua pass3
                    store_block(33013, 245, 87552, nil)
                endlua

                ; компиляция блока S13 и размещение по исходному смещению диска
                include "Source/Files/13_PERSON3.asm"
                lua pass3
                    store_block(33258, 245, 87808, nil)
                endlua

                ; компиляция блока S14 и размещение по исходному смещению диска
                include "Source/Files/14_PERSON4.asm"
                lua pass3
                    store_block(33503, 245, 88064, nil)
                endlua

                ; компиляция блока S15 и размещение по исходному смещению диска
                include "Source/Files/15_PERSON5.asm"
                lua pass3
                    store_block(33748, 245, 88320, nil)
                endlua

                ; компиляция блока S16 и размещение по исходному смещению диска
                include "Source/Files/16_PERSON6.asm"
                lua pass3
                    store_block(33993, 245, 88576, nil)
                endlua

                ; компиляция блока S17 и размещение по исходному смещению диска
                include "Source/Files/17_PERSON7.asm"
                lua pass3
                    store_block(34238, 270, 88832, nil)
                endlua

                ; компиляция блока S18 и размещение по исходному смещению диска
                include "Source/Files/18_PERSON8.asm"
                lua pass3
                    store_block(34508, 245, 89344, nil)
                endlua

                ; компиляция блока S19 и размещение по исходному смещению диска
                include "Source/Files/19_STROENIA.asm"
                lua pass3
                    store_block(31281, 7210, 89600, nil)
                endlua

                ; компиляция блока S20 и размещение по исходному смещению диска
                include "Source/Files/20_NAZWANIE.asm"
                lua pass3
                    store_block(49152, 3200, 97024, nil)
                endlua

                ; компиляция блока S21 и размещение по исходному смещению диска
                include "Source/Files/21_SOLDIERS.asm"
                lua pass3
                    store_block(50944, 1050, 100352, nil)
                endlua

                ; компиляция блока S22 и размещение по исходному смещению диска
                include "Source/Files/22_WERWOIN1.asm"
                lua pass3
                    store_block(32768, 2000, 101632, nil)
                endlua

                ; компиляция блока S23 и размещение по исходному смещению диска
                include "Source/Files/23_WERWOIN2.asm"
                lua pass3
                    store_block(34768, 2000, 103680, nil)
                endlua

                ; компиляция блока S24 и размещение по исходному смещению диска
                include "Source/Files/24_WERWOIN3.asm"
                lua pass3
                    store_block(36768, 2000, 105728, nil)
                endlua

                ; компиляция блока S25 и размещение по исходному смещению диска
                include "Source/Files/25_MGPOWER1.asm"
                lua pass3
                    store_block(32768, 110, 107776, nil)
                endlua

                ; компиляция блока S26 и размещение по исходному смещению диска
                include "Source/Files/26_MGPOWER2.asm"
                lua pass3
                    store_block(32878, 115, 108032, nil)
                endlua

                ; компиляция блока S27 и размещение по исходному смещению диска
                include "Source/Files/27_MGPOWER3.asm"
                lua pass3
                    store_block(32993, 110, 108288, nil)
                endlua

                ; компиляция блока S28 и размещение по исходному смещению диска
                include "Source/Files/28_KARTA1.asm"
                lua pass3
                    store_block(32768, 16100, 108544, nil)
                endlua

                ; компиляция блока S29 и размещение по исходному смещению диска
                include "Source/Files/29_KARTA2.asm"
                lua pass3
                    store_block(32768, 16100, 124672, nil)
                endlua

                ; компиляция блока S30 и размещение по исходному смещению диска
                include "Source/Files/30_KARTA3.asm"
                lua pass3
                    store_block(32768, 16100, 140800, nil)
                endlua

                ; компиляция блока S31 и размещение по исходному смещению диска
                include "Source/Files/31_KARTA4.asm"
                lua pass3
                    store_block(32768, 16100, 156928, nil)
                endlua

                ; компиляция блока S32 и размещение по исходному смещению диска
                include "Source/Files/32_NAEMARMY.asm"
                lua pass3
                    store_block(59482, 1200, 173056, nil)
                endlua

                ; компиляция блока S33 и размещение по исходному смещению диска
                include "Source/Files/33_BL1.asm"
                lua pass3
                    store_block(49152, 14948, 174336, nil)
                endlua

                ; компиляция блока S34 и размещение по исходному смещению диска
                include "Source/Files/34_BL2.asm"
                lua pass3
                    store_block(49152, 13663, 189440, nil)
                endlua

                ; компиляция блока S35 и размещение по исходному смещению диска
                include "Source/Files/35_SPR1.asm"
                lua pass3
                    store_block(49152, 12080, 203264, nil)
                endlua

                ; компиляция блока S36 и размещение по исходному смещению диска
                include "Source/Files/36_IP1.asm"
                lua pass3
                    store_block(32768, 144, 215552, nil)
                endlua

                ; компиляция блока S37 и размещение по исходному смещению диска
                include "Source/Files/37_IP2.asm"
                lua pass3
                    store_block(32912, 144, 215808, nil)
                endlua

                ; компиляция блока S38 и размещение по исходному смещению диска
                include "Source/Files/38_IP3.asm"
                lua pass3
                    store_block(33056, 144, 216064, nil)
                endlua

                ; компиляция блока S39 и размещение по исходному смещению диска
                include "Source/Files/39_IP4.asm"
                lua pass3
                    store_block(33200, 144, 216320, nil)
                endlua

                ; компиляция блока S40 и размещение по исходному смещению диска
                include "Source/Files/40_IP5.asm"
                lua pass3
                    store_block(33344, 144, 216576, nil)
                endlua

                ; компиляция блока S41 и размещение по исходному смещению диска
                include "Source/Files/41_IP6.asm"
                lua pass3
                    store_block(33488, 144, 216832, nil)
                endlua

                ; компиляция блока S42 и размещение по исходному смещению диска
                include "Source/Files/42_IP7.asm"
                lua pass3
                    store_block(33632, 144, 217088, nil)
                endlua

                ; компиляция блока S43 и размещение по исходному смещению диска
                include "Source/Files/43_IP8.asm"
                lua pass3
                    store_block(33776, 144, 217344, nil)
                endlua

                ; компиляция блока S44 и размещение по исходному смещению диска
                include "Source/Files/44_SPR2.asm"
                lua pass3
                    store_block(49152, 16128, 217600, nil)
                endlua

                ; компиляция блока S45 и размещение по исходному смещению диска
                include "Source/Files/45_SPR3.asm"
                lua pass3
                    store_block(49152, 16384, 233728, nil)
                endlua

                ; компиляция блока S46 и размещение по исходному смещению диска
                include "Source/Files/46_DATA1.asm"
                lua pass3
                    store_block(50202, 3643, 250112, nil)
                endlua

                ; компиляция блока S47 и размещение по исходному смещению диска
                include "Source/Files/47_bitwa_co.asm"
                lua pass3
                    store_block(53845, 11583, 253952, nil)
                endlua

                ; компиляция блока S50 и размещение по исходному смещению диска
                include "Source/Files/50_BAD.asm"
                lua pass3
                    store_block(16384, 6912, 291072, nil)
                endlua

                ; компиляция блока S51 и размещение по исходному смещению диска
                include "Source/Files/51_TEXT.asm"
                lua pass3
                    store_block(34928, 532, 297984, nil)
                endlua

                ; компиляция блока S52 и размещение по исходному смещению диска
                include "Source/Files/52_HELPG_tx.asm"
                lua pass3
                    store_block(30500, 23799, 298752, "Tools/Disasm/Disk/Keys/S52.xor")
                endlua

                ; компиляция блока S53 и размещение по исходному смещению диска
                include "Source/Files/53_DEADLY.asm"
                lua pass3
                    store_block(0, 35584, 322560, nil)
                endlua

                ; компиляция блока KBO и размещение по исходному смещению диска
                include "Source/Loader/KB_Outer.asm"
                lua pass3
                    capture_kb(24905, 28, 0)
                endlua

                ; компиляция блока KBR и размещение по исходному смещению диска
                include "Source/Loader/KB_Relocate.asm"
                lua pass3
                    capture_kb(24933, 79, 28)
                endlua

                ; компиляция блока KBD и размещение по исходному смещению диска
                include "Source/Loader/KB_Difference.asm"
                lua pass3
                    capture_kb(49117, 35, 107)
                endlua

                ; компиляция блока KBL и размещение по исходному смещению диска
                include "Source/Loader/KB_LoadBL3.asm"
                lua pass3
                    capture_kb(49152, 257, 142)
                endlua

                ; компиляция блока KBT и размещение по исходному смещению диска
                include "Source/Loader/KB_Tail.asm"
                lua pass3
                    capture_kb(49409, 7, 399)
                endlua

                ; компиляция блока O01 и размещение по исходному смещению диска
                include "Source/Overlays/Capture.asm"
                lua pass3
                    store_block(45568, 1904, 265728, nil)
                endlua

                ; компиляция блока O02 и размещение по исходному смещению диска
                include "Source/Overlays/City.asm"
                lua pass3
                    store_block(45568, 3084, 267632, nil)
                endlua

                ; компиляция блока O03 и размещение по исходному смещению диска
                include "Source/Overlays/Temple.asm"
                lua pass3
                    store_block(45568, 1133, 270716, nil)
                endlua

                ; компиляция блока O04 и размещение по исходному смещению диска
                include "Source/Overlays/Recruit.asm"
                lua pass3
                    store_block(45568, 656, 271849, nil)
                endlua

                ; компиляция блока O05 и размещение по исходному смещению диска
                include "Source/Overlays/Treasure.asm"
                lua pass3
                    store_block(45568, 1530, 272505, nil)
                endlua

                ; компиляция блока O06 и размещение по исходному смещению диска
                include "Source/Overlays/Join.asm"
                lua pass3
                    store_block(45568, 342, 274035, nil)
                endlua

                ; компиляция блока O07 и размещение по исходному смещению диска
                include "Source/Overlays/Bandits.asm"
                lua pass3
                    store_block(45568, 598, 274377, nil)
                endlua

                ; компиляция блока O08 и размещение по исходному смещению диска
                include "Source/Overlays/Army.asm"
                lua pass3
                    store_block(45568, 1106, 274975, nil)
                endlua

                ; компиляция блока O09 и размещение по исходному смещению диска
                include "Source/Overlays/Save.asm"
                lua pass3
                    store_block(45568, 355, 276081, nil)
                endlua

                ; компиляция блока O10 и размещение по исходному смещению диска
                include "Source/Overlays/Dismiss.asm"
                lua pass3
                    store_block(45568, 1089, 276436, nil)
                endlua

                ; компиляция блока O11 и размещение по исходному смещению диска
                include "Source/Overlays/TakeOff.asm"
                lua pass3
                    store_block(45568, 217, 277525, nil)
                endlua

                ; компиляция блока O12 и размещение по исходному смещению диска
                include "Source/Overlays/Land.asm"
                lua pass3
                    store_block(45568, 37, 277742, nil)
                endlua

                ; компиляция блока O13 и размещение по исходному смещению диска
                include "Source/Overlays/Maps.asm"
                lua pass3
                    store_block(45568, 1974, 277779, nil)
                endlua

                ; компиляция блока O14 и размещение по исходному смещению диска
                include "Source/Overlays/Sail.asm"
                lua pass3
                    store_block(45568, 610, 279808, nil)
                endlua

                ; компиляция блока O15 и размещение по исходному смещению диска
                include "Source/Overlays/TargetMap.asm"
                lua pass3
                    store_block(45568, 293, 280418, nil)
                endlua

                ; компиляция блока O16 и размещение по исходному смещению диска
                include "Source/Overlays/Victory.asm"
                lua pass3
                    store_block(45568, 1161, 280711, nil)
                endlua

                ; компиляция блока O17 и размещение по исходному смещению диска
                include "Source/Overlays/Info.asm"
                lua pass3
                    store_block(45568, 2740, 281872, nil)
                endlua

                ; компиляция блока O18 и размещение по исходному смещению диска
                include "Source/Overlays/Friendly.asm"
                lua pass3
                    store_block(45568, 859, 284612, nil)
                endlua

                ; компиляция блока O19 и размещение по исходному смещению диска
                include "Source/Overlays/Hostile.asm"
                lua pass3
                    store_block(45568, 866, 285471, nil)
                endlua

                ; компиляция блока O20 и размещение по исходному смещению диска
                include "Source/Overlays/Defeat.asm"
                lua pass3
                    store_block(45568, 522, 286337, nil)
                endlua

                ; компиляция блока O21 и размещение по исходному смещению диска
                include "Source/Overlays/Castle.asm"
                lua pass3
                    store_block(45568, 2933, 286859, nil)
                endlua

                ; компиляция блока O22 и размещение по исходному смещению диска
                include "Source/Overlays/Help.asm"
                lua pass3
                    store_block(45568, 1159, 289792, nil)
                endlua

                ; обратное преобразование многослойного загрузчика и завершение образа
                lua pass3
                    finish_kb(13824)
                    finish_image(_c("VerifyOriginal") ~= 0)
                endlua
