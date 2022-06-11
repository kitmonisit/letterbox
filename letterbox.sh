#!env zsh

# https://stackoverflow.com/a/50497981
. `which env_parallel.zsh`

env_parallel --session

DIR="${HOME}/Desktop/tmp/16-9"

letterbox_func () {
    readonly fname=$1
    readonly width=`identify -format "%w" $fname`
    (( height_new=$width * 3 / 4 ))
    readonly dimensions="${width}x${height_new}"
    convert $fname \
        -resize $dimensions \
        -background Black \
        -gravity center \
        -extent $dimensions \
        ${fname}_centered.jpeg
    echo $fname $dimensions
}

find $DIR \
    -type f \
    -name "*.jpeg" |
    env_parallel --jobs 7 letterbox_func

unset -f letterbox_func

env_parallel --end-session

exiftool "-FileModifyDate<CreateDate" .
