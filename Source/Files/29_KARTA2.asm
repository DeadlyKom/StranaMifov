; стратегическая карта 2, 100 строк по 161 байту
; исходный файл каталога 29, смещение #0000
                module Maps
                module Continent2
                org #8000

Cells           INCBIN "Assets/Maps/Continent2.map"                             ; графический ресурс, исходное смещение #0000

                assert $ = #BEE4
                endmodule
                endmodule
