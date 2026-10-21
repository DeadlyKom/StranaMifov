# Сборка и проверка

SjASMPlus 1.23.1 собрал текущие исходники с **0 ошибок и 0 предупреждений**.
Дата отчёта UTC: `2026-10-21T04:58:23.248096+00:00`.

Выполнена команда задачи `Build` из [tasks.json](../.vscode/tasks.json):

```powershell
.\Tools\Sjasmplus\sjasmplus.exe --fullpath=rel --lst=Tmp/MYTHLAND.lst --sym=Tmp/MYTHLAND.sym Builder/Main.asm
```

- [MYTHLAND.trd](../MYTHLAND.trd), 655360 байт, побайтово совпал с [оригиналом](../Tools/Disasm/Disk/original.trd)
- SHA-256: `08b0e7fd5c59bc104c9de623d2bd0bc2ff0dabf43c340cca6a06b165d2232717`
- [MYTHLAND.lst](../Tmp/MYTHLAND.lst) и [MYTHLAND.sym](../Tmp/MYTHLAND.sym) получены этим запуском
- Проверены все 7917 значений [реестра символов](Symbols.md), расхождений нет
- Статическая сверка подтвердила 81 блок, 348741 байт активного содержимого, 22242 инструкции и 486 установленных входов
- Сборка сохранила исходники и метаданные Git без изменений

Упаковку диска выполняет встроенный Lua sjasmplus через [Tools/pack.lua](../Tools/pack.lua). Отдельный сборочный PowerShell-сценарий не требуется. Изменять и пересобирать проект можно через `Ctrl+B` в VS Code, образ сохраняется в корне проекта, листинг и символы в `Tmp`.

В исходниках проверены 1680 пояснений условных инструкций. Обращения к известным структурам используют имена полей, нулевое смещение прочих курсоров записано явно как `(IX + #00)` или `(IY + #00)`. Для 39 битовых полей сохранены 40 схем, для инструкций определены 108 имён позиций и 82 маски. После RET, JR, JP и DJNZ сохранены разделительные пустые строки.

Подробные отчёты: [BuildVerification.json](../Tools/Disasm/Reports/BuildVerification.json), [StaticVerification.json](../Tools/Disasm/Reports/StaticVerification.json), [SymbolAudit.json](../Tools/Disasm/Reports/SymbolAudit.json), [ReadabilityAudit.json](../Tools/Disasm/Reports/ReadabilityAudit.json), [FlagConstantsVerification.json](../Tools/Disasm/Reports/FlagConstantsVerification.json).

Полный вывод ассемблера приведён в [BuildLog.md](BuildLog.md), машинная копия — [BuildLog.txt](../Tools/Disasm/Reports/BuildLog.txt). Границы подтверждённого поведения перечислены в [VerificationLimits.md](VerificationLimits.md).

Оригинал и пересобранный диск проверены в полном эмуляторе до меню CTPAHA. Полученные экраны совпали по всем 6912 байтам, см. [проверку запуска](RuntimeVerification.md).
