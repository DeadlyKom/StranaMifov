; три кандидата движения, изменяемые процедурами Steps*
; проверено по коду, MakeSteps создаёт подряд три FMoveStep, Steps* меняют их X/Y
                struct FMoveStepA3
First           FMoveStep                                                       ; кандидат 1
Second          FMoveStep                                                       ; кандидат 2
Third           FMoveStep                                                       ; кандидат 3
                ends
                assert FMoveStepA3 = 9
