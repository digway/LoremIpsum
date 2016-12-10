function New-IgLoremIpsum {
    <#
    .Synopsis
        Creates Lorem Ipsum paragraphs.
    .Description
        User inputs how many paragraphs or words they need they need, defaults to 5 paragraphs.
        Then, foreach paragraph generates a number of sentences between 4 and 10.
        And foreach sentence, generates a number of words that are 4 to 10 characters long.
        Then foreach word, randomly generates the letters.
        The first letter of the sentences are capitalized and the very first words are "Lorem Ipsum"

        You cannot request more than 100 paragraphs or 5000 words. This won't be an exact number
        due to the randomness of the script, but it'll be sorta close.
    .Example
        New-IgLoremIpsum
        This will generate 5 paragraphs of Lorem Ipsum.
    .Example
        New-IgLoremIpsum -Paragraphs 10
        This will generate 10 paragraphs of Lorem Ipsum.
    .Inputs
        None required, but an integer of how many paragraphs or words to generate.
    .Outputs
        string
    .Notes
        Created by donn@thehouseofdonn.com
        Created on 2016-12-07
    .Link
        http://www.powershellusers.com
    .Link
        http://donnigway.wordpress.com
    #>
    [CmdletBinding(DefaultParameterSetName = 'DefParamSet',
                   SupportsShouldProcess = $true,
                   PositionalBinding = $false,
                   ConfirmImpact = 'Medium')]
    [OutputType([String])]
    Param (
        # This is a number of how many paragraphs you want to create. Max is 100 paragraphs.
        [Parameter(Mandatory = $false,
                   ParameterSetName = 'DefParamSet')]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [ValidateRange(1, 100)]
        [int]$Paragraphs = 5,
        
        # This is how words to generate. Based on how many words, the script will figure out how many paragraphs are needed. The maximum number of words to tell the script is 5000.
        [Parameter(Mandatory = $true,
                   ParameterSetName = 'ParamSet2')]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [ValidateRange(3, 5000)]
        [int]$Count
    )
    Begin {
        Function Get-IgCurrentLineNumber {
            # Simply Displays the Line number within the script.
            [string]$line = $MyInvocation.ScriptLineNumber
            $line.PadLeft(4, '0')
        }
        
        $list = @('a', 'a', 'b', 'c', 'd', 'e', 'e', 'f', 'g', 'h', 'i', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'o', 'p', 'q', 'r', 's', 't', 'u', 'u', 'v', 'w', 'x', 'y', 'z')
        
        if ($PSBoundParameters.ContainsKey('Count')) {
            [int]$Paragraphs = [int](($Count + 200)/80)
            Write-Verbose "[Line: $(Get-IgCurrentLineNumber)] Paragraphs from Count: $Paragraphs"
        }
    }
    Process {
        [string]$allLoremIpsum = @()
        $totalWords = 0
        $FirstParagraph = $true
        
        #region Looping thru each Paragraph.
        for ($p = 1; $p -lt ($Paragraphs + 1); $p++) {
            Write-Verbose "[Line: $(Get-IgCurrentLineNumber)] Paragraph '$p'"
            [string]$currentParagraph = @()
            
            #region Figure out the number of sentences
            $sentencesInParagraph = Get-Random -Minimum 4 -Maximum 18
            for ($s = 1; $s -lt ($sentencesInParagraph + 1); $s++) {
                Write-Verbose "[Line: $(Get-IgCurrentLineNumber)]   Sentence '$s'"
                [string]$currentSentence = @()
                
                #region Figure out how many words are in the sentence
                $wordsInSentence = Get-Random -Minimum 4 -Maximum 18
                #[int]$WordCountInSentence = 0
                for ($w = 1; $w -lt ($wordsInSentence + 1); $w++) {
                    
                    Write-Verbose "[Line: $(Get-IgCurrentLineNumber)]     Word '$w'"
                    [string]$currentWord = @()
                    
                    #region Adding Letters to words
                    if ($p -eq 1 -and $s -eq 1 -and $w -eq 1) {
                        # Write-Verbose "[Line: $(Get-IgCurrentLineNumber)]     Lorem Ipsum"
                        $currentWord += "Lorem Ipsum"
                        $totalWords += 2
                    } else {
                        for ($l = 1; $l -lt ((Get-Random -Minimum 4 -Maximum 10) + 1); $l++) {
                            if ($w -eq 1 -and $l -eq 1) {
                                $currentLetter = ($list | Get-Random).ToUpper()
                                # Write-Verbose "[Line: $(Get-IgCurrentLineNumber)]       Letter '$l' '$currentLetter'"
                            } else {
                                $currentLetter = $list | Get-Random
                                # Write-Verbose "[Line: $(Get-IgCurrentLineNumber)]       Letter '$l' '$currentLetter'"
                            }
                            $currentWord += $currentLetter
                        }
                        $totalWords++
                        
                    } # ending adding letters to words
                    #endregion
                    
                    if ($currentWord -ne 'Lorem Ipsum') {
                        $currentWord = ($currentWord -replace '[^\w]', '')
                    }
                    
                    if ($PSBoundParameters.ContainsKey('Count')) {
                        if ($totalWords -eq $Count) {
                            Write-Verbose -Message "[Line: $(Get-IgCurrentLineNumber)] I want to stop. Now!"
                            $currentWord = " $currentWord."
                            
                            # Chaning Values to something bigger than the loops
                            $w = $wordsInSentence + $w
                            $s = $sentencesInParagraph + $s
                            $p = $Paragraphs + $p
                        } else {
                            if ($w -eq $wordsInSentence) {
                                # Write-Verbose "[Line: $(Get-IgCurrentLineNumber)] Period"
                                $currentWord = " $currentWord."
                            } else {
                                # Write-Verbose "[Line: $(Get-IgCurrentLineNumber)] Space"
                                if ($w -eq 1 -and $s -eq 1) {
                                    $currentWord = "$currentWord"
                                } else {
                                    $currentWord = " $currentWord"
                                }
                            }
                        }
                    } else {
                        if ($w -eq $wordsInSentence) {
                            # Write-Verbose "[Line: $(Get-IgCurrentLineNumber)] Period"
                            $currentWord = " $currentWord."
                        } else {
                            # Write-Verbose "[Line: $(Get-IgCurrentLineNumber)] Space"
                            if ($w -eq 1 -and $s -eq 1) {
                                $currentWord = "$currentWord"
                            } else {
                                $currentWord = " $currentWord"
                            }
                        }
                    }
                    
                    Write-Debug -Message "Ending Word"
                    
                    # Write-Verbose "[Line: $(Get-IgCurrentLineNumber)]     Current Word: '$currentWord'"
                    $currentSentence += $currentWord
                    
                } # ending words
                #endregion
                
                Write-Verbose "[Line: $(Get-IgCurrentLineNumber)]   Current Sentence: $currentSentence"
                Write-Verbose "[Line: $(Get-IgCurrentLineNumber)]   Current Words In Sentence: $wordsInSentence"
                
                Write-Verbose "[Line: $(Get-IgCurrentLineNumber)]   Total Words: $totalWords"
                $currentParagraph += $currentSentence
                Write-Debug -Message "Ending Sentence"
            } # ending Sentences
            #endregion
            
            if ($FirstParagraph) {
                Write-Verbose "[Line: $(Get-IgCurrentLineNumber)] First PP"
                $allLoremIpsum = @"
$currentParagraph
"@
                $FirstParagraph = $false
            } else {
                Write-Verbose "[Line: $(Get-IgCurrentLineNumber)] Not first PP"
                $allLoremIpsum += @"

$currentParagraph
"@
                Write-Debug -Message "Ending Paragraph"
            }
        } # ending paragraph
        #endregion
        
    }
    End {
        Write-Verbose "[Line: $(Get-IgCurrentLineNumber)] Output Total Words: $totalWords"
        $allLoremIpsum
    }
}
