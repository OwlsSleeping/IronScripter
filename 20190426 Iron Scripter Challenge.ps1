
[int[]]$Encoded = @'
Rtsfi%nx%ymj%sj}y%ljsjwfynts%uqfyktwr%ktw%firnsnxywfyn{j%fzytrfynts3%%Rtsfi%xtq{jx%ywfinyntsfq%rfsfljrjsy%uwtgqj
    rx%g~%qj{jwflnsl%ymj%3Sjy%Uqfyktwr3%%Kwtr%tzw%uwtyty~uj%-ymtzlm%qnrnyji.1%|j%hfs%uwtojhy%xnlsnknhfsy%gjsjknyx%yt
'@.ToCharArray()

[char[]]$Plain = ''
$Plain = ''
Foreach($Letter in $Encoded){
    $Plain += [char]($Letter - 5)
}
[String]::new($Plain)