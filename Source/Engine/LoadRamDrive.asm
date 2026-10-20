
; -----------------------------------------
; загрузить RAMDRIVE в служебную область #5FA0
; копирует 9 байт имени RAMDRIVEC из #62A7 в #5CDD и вызывает TR-DOS через #6D15, адрес загрузки
; #5FA0
; In:
;   TR-DOS доступен, область #5FA0 для загрузки RAMDRIVE
; Out:
;   RAMDRIVE загружен по #5FA0, после CALL #6D15 выполнение продолжается в #6335 без RET
; Corrupt:
;   HL, DE, BC, AF, IX, IY и регистры TR-DOS, далее инициализация меняет SP, I, IM и IFF
; -----------------------------------------
LoadRamDrive    LD HL, Engine.Interrupt.RamDriveFile                            ; имя RAMDRIVEC для загрузки драйвера банков
                LD DE, TrDos.Descriptor                                         ; рабочее имя RAMDRIVE в описателе TR-DOS
                LD BC, #0009
                LDIR
                XOR A
                LD (TrDos.Error), A
                LD HL, State.Bank
                LD C, #0E
                LD A, #03
                CALL CallTrdos                                                  ; вызвать TR-DOS с временным режимом IM 1
