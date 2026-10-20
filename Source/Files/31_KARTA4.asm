; стратегическая карта 4, 100 строк по 161 байту
; исходный файл каталога 31, смещение #0000
                module Maps
                module Continent4
                org #8000

Cells           INCBIN "Assets/Maps/Continent4.map"                             ; графический ресурс, исходное смещение #0000

                assert $ = #BEE4
                endmodule
                endmodule
