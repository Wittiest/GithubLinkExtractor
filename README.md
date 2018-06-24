# Github Link Extractor
## Description
This program allows you to extract all of the links from a Github repository. It requires login details for private repositories. It will write these links to a file named "links.yaml" and prepend to this file if it already exists.

## Usage

```shell
git clone https://github.com/Wittiest/GithubLinkExtractor.git
cd GithubLinkExtractor
ruby interface.rb
#Enter a link in the following format(https://github.com/USER/REPO_NAME):
"Link:" REPO_LINK_HERE
"Username:" GITHUB_USERNAME
"Password:" GITHUB_PASSWORD
#Program stores links in links.yml (YAML) file of a hash where:
  #key = URL of .md file with link
  #value = all links in key file
```
