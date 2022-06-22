#region function_in_loop

1..10 | Foreach-Object -Parallel {

    # function INSIDE of Foreach/Parallel
    function Be-Polite ($when, $who) {
        Write-Host ("Good {0}, {1}!" -f $when, $who)
    }

    $daytime = 'Morning','Day','Afternoon','Evening','Night'
    $name = 'Jeff','Crissy','Tobias','Jessie','Patrick'

    $x = (get-random -Maximum $daytime.count)
    $y = (get-random -Maximum $name.count)

    Be-Polite -When $daytime[$x] -Who $name[$y]
}

#endregion function_in_loop



#region function_dotsourced

1..10 | Foreach-Object -Parallel {

    # EXTERNAL function file DOTSOURCED in Foreach/Parallel
    . ".\function_Be-Polite.ps1"

    $daytime = 'Morning','Day','Afternoon','Evening','Night'
    $name = 'Jeff','Crissy','Tobias','Jessie','Patrick'

    $x = (get-random -Maximum $daytime.count)
    $y = (get-random -Maximum $name.count)

    # run the function
    Be-Polite -When $daytime[$x] -Who $name[$y]
}

#endregion function_dotsourced



#region block2string2block

# define function as SCRIPTBLOCK
$sb_loop_function =  {
    param($when, $who)
    Write-Host ("Good {0}, {1}!" -f $when, $who)
}

# convert SB to STRING
$str_loop_function = [string]$sb_loop_function

1..10 | Foreach-Object -Parallel {

    # convert STRING back TO SCRIPTBLOCK
    $sb_BePolite = [ScriptBlock]::Create($using:str_loop_function)

    $daytime = 'Morning','Day','Afternoon','Evening','Night'
    $name = 'Jeff','Crissy','Tobias','Jessie','Patrick'

    $x = (get-random -Maximum $daytime.count)
    $y = (get-random -Maximum $name.count)

    # run scriptblock
    & $sb_BePolite -When $daytime[$x] -Who $name[$y]
}

#endregion string2block



#region Function_in_parallel

# function INSIDE of Foreach/Parallel
function Be-Polite ($when, $who) {
    Write-Host ("Good {0}, {1}!" -f $when, $who)
}

# get scriptblock of function and convert it to string to be able to hand it to the loop
$str_Function = $function:Be-Polite

1..10 | Foreach-Object -Parallel {

    # convert string back to scriptblock
    $sb_BePolite = [ScriptBlock]::Create($using:str_Function)

    $daytime = 'Morning','Day','Afternoon','Evening','Night'
    $name = 'Jeff','Crissy','Tobias','Jessie','Patrick'

    $x = (get-random -Maximum $daytime.count)
    $y = (get-random -Maximum $name.count)

    # run scriptblocked function
    & sp_BePolite -When $daytime[$x] -Who $name[$y]
}


#endregion Function_in_parallel





#region Filters

$Filter = '$eins -eq 1'
$additionalFilter = '$zwei -eq 2'

$eins = 1
$zwei = 3

if (& ([scriptblock]::Create($Filter))) { $true } else { $false }

$Filter = @($Filter,$additionalFilter) -join ' -and '

if (& ([scriptblock]::Create($Filter))) { $true } else { $false }

#endregion Filters