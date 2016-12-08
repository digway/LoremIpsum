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
    [CmdletBinding(DefaultParameterSetName='DefParamSet',
        SupportsShouldProcess=$true,
        PositionalBinding=$false,
        ConfirmImpact='Medium')]
    [OutputType([String])]
    Param (
        # This is a number of how many paragraphs you want to create. Max is 100 paragraphs.
        [Parameter(Mandatory=$false,
            ParameterSetName='DefParamSet')]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [ValidateRange(1,100)]
        [int]$Paragraphs = 5,

        # This is how many estimated words to generate. Based on how many words, the script will figure out how many paragraphs are needed. The maximum number of words to tell the script is 5000.
        [Parameter(Mandatory=$true,
            ParameterSetName='ParamSet2')]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [ValidateRange(0,5000)]
        [int]$Count
    )
    Begin {
        $list = @('a','a','b','c','d','e','e','f','g','h','i','i','j','k','l','m','n','o','o','p','q','r','s','t','u','u','v','w','x','y','z')
        # $list = (97..122) | foreach {[char]$_}

        if ($PSBoundParameters.ContainsKey(‘Count’)) {
            [int]$Paragraphs = [int](($Count+50)/80)
            Write-Verbose "Paragraphs from Count: $Paragraphs"
        }
    }
    Process {
        [string]$allLoremIpsum = @()
        $totalWords = 0
        $FirstParagraph = $true

        # Looping thru each Paragraph.
        for ($p = 1; $p -lt ($Paragraphs + 1); $p++) {
            Write-Verbose -Message "Paragraph '$p'"
            [string]$currentParagraph = @()

            # Figure out the number of sentences
            for ($s = 1; $s -lt ((Get-Random -Minimum 4 -Maximum 18) + 1); $s++) {
                Write-Verbose -Message "  Sentence '$s'"
                [string]$currentSentence = @()

                # Figure out how many words are in the sentence
                $wordsInSentence = Get-Random -Minimum 4 -Maximum 18
                for ($w = 1; $w -lt ($wordsInSentence + 1); $w++) {
                    
                    Write-Verbose -Message "    Word '$w'"
                    [string]$currentWord = @()

                    if ($p -eq 1 -and $s -eq 1 -and $w -eq 1) {
                        Write-Verbose "Lorem Ipsum"
                        $currentWord += "Lorem Ipsum"
                    } else {
                        for ($l = 1; $l -lt ((Get-Random -Minimum 4 -Maximum 10) + 1); $l++) {
                            
                            if ($w -eq 1 -and $l -eq 1) {
                                $currentLetter = ($list | Get-Random).ToUpper()
                                Write-Verbose -Message "      Letter '$l' '$currentLetter'"
                            } else {
                                $currentLetter = $list | Get-Random
                                Write-Verbose -Message "      Letter '$l' '$currentLetter'"
                            }
                            $currentWord += $currentLetter
                        }
                    } # ending adding letters to words

                    if ($currentWord -ne 'Lorem Ipsum') {
                        $currentWord = ($currentWord -replace '[^\w]', '')
                    }

                    if ($w -eq $wordsInSentence) {
                        Write-Verbose "Period"
                        $currentWord = "$currentWord."
                    } else {
                        Write-Verbose "Space"
                        if ($w -eq 1 -and $s -eq 1) {
                            $currentWord = "$currentWord"
                        } else {
                            $currentWord = " $currentWord"
                        }
                    }

                    Write-Verbose "Current Word: '$currentWord'"
                    $currentSentence += $currentWord

                } # ending words
                
                Write-Verbose "Current Sentence: $currentSentence"
                Write-Verbose "Current Words In Sentence: $wordsInSentence"
                $totalWords += $wordsInSentence
                $currentParagraph += $currentSentence

            } #ending Sentences

            if ($FirstParagraph) {
                Write-Verbose "First PP"
                $allLoremIpsum = @"
$currentParagraph
"@
                $FirstParagraph = $false
            } else {
                Write-Verbose "Not first PP"
                $allLoremIpsum += @"

$currentParagraph
"@
                }
        } #ending paragraph
    }
    End {
        Write-Verbose "Output Total Words: $totalWords"
        $allLoremIpsum
    }
}

