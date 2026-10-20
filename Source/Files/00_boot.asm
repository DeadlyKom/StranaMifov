; BASIC-загрузчик дисковой версии
; исходный файл каталога 00, смещение #0000
                module Basic
                module Boot
                org #5D3B

                DB #00, #0A, #1B, #00, #D9, #C0, #B0, #22
                DB #31, #35, #36, #31, #39, #22, #3A, #EA
                DB #3A, #4C, #4F, #41, #44, #20, #22, #43
                DB #54, #50, #41, #48, #41, #22, #0D

                assert $ = #5D5A
                endmodule
                endmodule
