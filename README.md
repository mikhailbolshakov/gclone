# gclone
bash script to clone/pull all repositories available for the current user 

# installation
the script uses `jq` tool to manipulate with JSON, so you have to install `jq` first 
````
sudo apt-get install jq
````
# before usage

Please, make sure you have SSH public key installed on your gitlab server to be able to establish ssh connection

To ba able to use from any location copy script to `/usr/bin` directory and give `+x` permission

# usage

    gclone [--help] [-r repository] [-t token]
      --help - print help"
      -r repository - specify http(s) url to gitlab ripository with backslash
      -t token - specify private gitlab token that can be obtain on gitlab account setting page

    example: gclone -r "https://gitlab.example.com/" -t 4g-YxrAXKuJa5kapqsDF


