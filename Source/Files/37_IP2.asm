; графический блок героя 2, 144 байта
; исходный файл каталога 37, смещение #0000
                module Graphics
                module Portrait2
                org #8090

Bitmap          INCBIN "Assets/Portraits/Hero02.ink"                            ; графический ресурс, исходное смещение #0000
Attributes      INCBIN "Assets/Portraits/Hero02.attr"                           ; графический ресурс, исходное смещение #0080

                assert $ = #8120
                endmodule
                endmodule
