# BASIC-программы образа

Листинг `boot.B`, `Credits.B` и `CTPAHA.B` с пояснениями скрытых числовых значений.

```text
=== boot.B ===
  10 INK USR VAL "15619": REM :LOAD "CTPAHA"

=== Credits.B ===
  10 BORDER NOT PI: PAPER NOT PI: CLS 
  20 PRINT INK VAL "6";AT VAL "6",VAL "6";"'COUNTRY OF MYTH'S";AT VAL "7",VAL "10";"Version 2.0";AT VAL "11",VAL "2"; INK VAL "5";"Remixed and supplemented by";AT VAL "12",VAL "6";"E.Milun, A.Korolev.";AT VAL "19",VAL "4";"'STARS OF KELADAN' H.G.";AT VAL "20",VAL "3";"Russia, Samara, 6.8.1996": GO TO VAL "20"

=== CTPAHA.B ===
   1 CLEAR 36768{24499}: INK USR 8{23895}: REM !{0x00}{0x80} RESTORE {0x01}{0x05}{0x01}GO SUB [ POKE \NOT {0x133D}

Число в фигурных скобках после видимого литерала показывает скрытое значение
BASIC, если оно отличается от напечатанного текста
Машинный код в REM сохранён в ASM без преобразования токенов
```

[К оглавлению документации](README.md)
