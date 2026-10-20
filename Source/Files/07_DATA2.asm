; шрифт и общие графические данные
; исходный файл каталога 07, смещение #0000
                module Data
                module Core
                org #8000

FontGlyphs      INCBIN "Assets/Gfx/raw/DATA2_font_codes_032_255.bin"            ; графический ресурс, исходное смещение #0000
PostFontData    INCBIN "Assets/Gfx/raw/DATA2_after_font.bin"                    ; графический ресурс, исходное смещение #0700

                assert $ = #9F27
                endmodule
                endmodule
