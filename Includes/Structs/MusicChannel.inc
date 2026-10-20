; состояние канала AY плеера меню
; проверено по коду, Music.Menu.InitPlayer, StepDuration, DecodeChannel, StepSample, ApplyEnvelope, IX направлен на поле Step, то есть base+2
                struct FMusicChannel
EnvelopeMode    DB #00                                                          ; 0 без огибающей, 1 включить её форму, 2 сохранять текущую форму
Duration        DB #00                                                          ; перезагрузка задержки чтения команд
Step            DB #00                                                          ; текущая позиция семпла, по модулю32
Note            DB #00                                                          ; номер ноты
Wait            DB #00                                                          ; оставшаяся задержка чтения команд
Sample          FWord                                                           ; адрес данных выбранного семпла
Ornament        FWord                                                           ; адрес выбранного орнамента
Remaining       DB #00                                                          ; оставшиеся шаги семпла, #FF выключает канал
                ends
                assert FMusicChannel = 10
