; стратегическая карта 1, 100 строк по 161 байту
; исходный файл каталога 28, смещение #0000
                module Maps
                module Continent1
                org #8000

Cells           INCBIN "Assets/Maps/Continent1.map"                             ; графический ресурс, исходное смещение #0000

                assert $ = #BEE4
                endmodule
                endmodule
