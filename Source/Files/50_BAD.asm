; экран ошибки, 6144 байта пикселей и 768 атрибутов
; исходный файл каталога 50, смещение #0000
                module Graphics
                module Defeat
                org #4000

Screen          INCBIN "Assets/Screens/Defeat.scr"                              ; графический ресурс, исходное смещение #0000

                assert $ = #5B00
                endmodule
                endmodule
