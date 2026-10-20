; графический блок героя 3, 144 байта
; исходный файл каталога 38, смещение #0000
                module Graphics
                module Portrait3
                org #8120

Bitmap          INCBIN "Assets/Portraits/Hero03.ink"                            ; графический ресурс, исходное смещение #0000
Attributes      INCBIN "Assets/Portraits/Hero03.attr"                           ; графический ресурс, исходное смещение #0080

                assert $ = #81B0
                endmodule
                endmodule
