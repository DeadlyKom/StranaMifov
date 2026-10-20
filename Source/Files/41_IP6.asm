; графический блок героя 6, 144 байта
; исходный файл каталога 41, смещение #0000
                module Graphics
                module Portrait6
                org #82D0

Bitmap          INCBIN "Assets/Portraits/Hero06.ink"                            ; графический ресурс, исходное смещение #0000
Attributes      INCBIN "Assets/Portraits/Hero06.attr"                           ; графический ресурс, исходное смещение #0080

                assert $ = #8360
                endmodule
                endmodule
