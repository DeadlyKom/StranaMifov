; графический блок героя 7, 144 байта
; исходный файл каталога 42, смещение #0000
                module Graphics
                module Portrait7
                org #8360

Bitmap          INCBIN "Assets/Portraits/Hero07.ink"                            ; графический ресурс, исходное смещение #0000
Attributes      INCBIN "Assets/Portraits/Hero07.attr"                           ; графический ресурс, исходное смещение #0080

                assert $ = #83F0
                endmodule
                endmodule
