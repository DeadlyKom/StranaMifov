; стратегическая карта 3, 100 строк по 161 байту
; исходный файл каталога 30, смещение #0000
                module Maps
                module Continent3
                org #8000

Cells           INCBIN "Assets/Maps/Continent3.map"                             ; графический ресурс, исходное смещение #0000

                assert $ = #BEE4
                endmodule
                endmodule
