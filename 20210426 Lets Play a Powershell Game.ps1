class DiceBox {
    [int]$Score
    [bool]$IsComplete
    [int[]]$RemainingNumbers

    DiceBox() {
        $This.Score = 0
        $This.IsComplete = 0
        $This.RemainingNumbers = @(1..9)
    }

    [int]RollDice([int]$NumberOfDice) {
        if ($NumberOfDice -notin 1,2) {
            throw 'One or Two dice should be thrown'
        }
        if ($NumberOfDice -eq 1 -and ($This.RemainingNumbers | Measure-Object -Maximum).Maximum -gt 6) {
            throw 'One dice can only be thrown if all remaining numbers are Six or less'
        }
        [int[]]$Results = @(1..$NumberOfDice).ForEach{
            Get-Random -Minimum 1 -Maximum 7
        }
        Write-Host "Your rolls are $($Results -join ' and ') for a total of $(($Results | Measure-Object -Sum).Sum)"
        return ($Results | Measure-Object -Sum).Sum
    }

    [void]TakeTurn() {
        [int]$NumberOfDice = Read-Host -Prompt "Would you like to roll one or two dice? Your remaining numbers are $($This.RemainingNumbers -join ', ')"
        [int]$Roll = $This.RollDice($NumberOfDice)
        [int[]]$RemainingNumbersClone = $This.RemainingNumbers.Clone()
        
        if ($This.IsComplete) {
            throw "This box has already been closed, with a final score of $($This.Score)"
        }

        if ($Roll -lt ($RemainingNumbersClone | Measure-Object -Minimum).Minimum) {
            Write-Host "With a roll of $Roll, your round is complete. Score of $(($This.RemainingNumbers | Measure-Object -Sum).Sum)"
            $This.Score = ($This.RemainingNumbers | Measure-Object -Sum).Sum
            $This.IsComplete = 1
            return
        }
        $RollRemaining = $Roll
        while ($RollRemaining -ne 0) {
            $UserInput = Read-Host -Prompt "Please enter a number to mark off. You have $RollRemaining points remaining to spend. Enter 0 to retry points assignment or 10 to complete your round"
            if ($UserInput -eq 10) {
                $This.IsComplete = 1
                $This.Score = ($This.RemainingNumbers | Measure-Object -Sum).Sum
                break
            }
            if ($UserInput -eq 0) {
                $RollRemaining = $Roll
                $RemainingNumbersClone = $This.RemainingNumbers.Clone()
                
            }
            if ($UserInput -notin $RemainingNumbersClone) {
                Write-Host 'Invalid Input'
                continue
            }
            #User input accepted
            $RollRemaining -= $UserInput
            $RemainingNumbersClone = $RemainingNumbersClone.Where{
                $_ -ne $UserInput
            }
        }
        $This.RemainingNumbers = $RemainingNumbersClone
        if ($RemainingNumbersClone.Count -eq 0) {
            Write-Host 'Perfect Score, Congratulations!'
            $This.IsComplete = 1
        }
        return
    }
}

[string]$PlayerName = ''
$Players = while ($true) {
    $PlayerName = Read-Host 'Enter player name. Enter blank to start once all names have been entered'
    if (!($PlayerName)) {
        break
    }
    [PSCustomObject]@{
        Name = $PlayerName
        Score = 0
    }
}

Write-Host "Game starting with the following players- $($Players.Keys -join ', ')"

$Players.foreach{
    Write-Host "---Player $($_.Name)'s turn---"
    $Box = [DiceBox]::new()
    while (!($Box.IsComplete)) {
        $Box.TakeTurn()
    }
    $_.Score = $Box.Score
}

Write-Host 'Scores are...'
$Players.GetEnumerator() | Sort-Object -Property Value

Write-Host "Winner is $(($Players.GetEnumerator() | Sort-Object -Property Value -Top 1).Name) with a score of $(($Players.GetEnumerator() | Sort-Object -Property Value -Top 1).Value). Congatulations!"