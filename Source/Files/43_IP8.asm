; графический блок героя 8, 144 байта
; исходный файл каталога 43, смещение #0000
                module Graphics
                module Portrait8
                org #83F0

Bitmap          INCBIN "Assets/Portraits/Hero08.ink"                            ; графический ресурс, исходное смещение #0000
Attributes      INCBIN "Assets/Portraits/Hero08.attr"                           ; графический ресурс, исходное смещение #0080

                assert $ = #8480
                endmodule
                endmodule
