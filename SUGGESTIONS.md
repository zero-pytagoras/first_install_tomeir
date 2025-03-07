# Suggestions

### Project
- Great readme file !!!
- Good use of License
- task needs to have extention, and capital letters
- contributors needs to have extention, and capital letters
- no links to task and contributors in readme
- 

### README
- Missing link to
  - INSTALL.md
  - CONTRIBUTORS.md
  - TASKS.md

### SCRIPT
- Great use of mktmp command!!!
- use `\` in arryas, because without it is considered as additional empty value
- no need to use '' in array elements
- you are suppose to use [[ instead of [
- functions should start with `function ` key word
- functions are not suppose to exit, only return value by 0/1 or echo something relevant, main function needs to decide whether to exit or not.
- why use so many `sudo` commands ? why not verify with EUID that root needs to run it ? please answer in PR
- when encoding, echo can be seen indebug mode, thus not secure -> use i/o redirect
- Great use of script process monitoring !!!
- use single `printf` command to format `help` function
- there is no validation that you are running on debian based OS, consider either prompting or checking the running env exiting based on /etc/os-release
  
