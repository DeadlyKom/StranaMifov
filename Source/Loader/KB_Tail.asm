; защищённый загрузчик, KB_Tail
; исходный файл каталога 03, смещение #018F
                module Protection
                module Tail
                org #C101

                DB #00, #00, #00, #00, #00, #00, #00

                assert $ = #C108
                endmodule
                endmodule
