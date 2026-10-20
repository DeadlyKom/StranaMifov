; графический блок героя 4, 144 байта
; исходный файл каталога 39, смещение #0000
                module Graphics
                module Portrait4
                org #81B0

Bitmap          INCBIN "Assets/Portraits/Hero04.ink"                            ; графический ресурс, исходное смещение #0000
Attributes      INCBIN "Assets/Portraits/Hero04.attr"                           ; графический ресурс, исходное смещение #0080

                assert $ = #8240
                endmodule
                endmodule
