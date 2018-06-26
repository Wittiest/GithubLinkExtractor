# Github Link Extractor
## Description
This program allows you to extract all of the links from a Github repository. It requires github login details for private repositories. It will write these links to a file named "links.yaml" and prepend to this file if it already exists.

Github may send an error (HTTP 429 Too Many Request) if the repository is extremely large. Because of this issue, the program stores the links 20 .md files at a time.

## Usage

```shell
git clone https://github.com/Wittiest/GithubLinkExtractor.git
cd GithubLinkExtractor
bundle install
ruby interface.rb

"Link:" https://github.com/USER/REPO_NAME
#If the repository is private, you will be asked for login information

#Program stores links in links.yml (YAML) file of a hash where:
  #key = URL of .md file with link
  #value = all links in key file
```
