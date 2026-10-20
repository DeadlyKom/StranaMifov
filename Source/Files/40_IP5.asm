; графический блок героя 5, 144 байта
; исходный файл каталога 40, смещение #0000
                module Graphics
                module Portrait5
                org #8240

Bitmap          INCBIN "Assets/Portraits/Hero05.ink"                            ; графический ресурс, исходное смещение #0000
Attributes      INCBIN "Assets/Portraits/Hero05.attr"                           ; графический ресурс, исходное смещение #0080

                assert $ = #82D0
                endmodule
                endmodule
