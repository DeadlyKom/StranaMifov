; графический блок героя 1, 144 байта
; исходный файл каталога 36, смещение #0000
                module Graphics
                module Portrait1
                org #8000

Bitmap          INCBIN "Assets/Portraits/Hero01.ink"                            ; графический ресурс, исходное смещение #0000
Attributes      INCBIN "Assets/Portraits/Hero01.attr"                           ; графический ресурс, исходное смещение #0080

                assert $ = #8090
                endmodule
                endmodule
