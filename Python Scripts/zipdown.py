#import urllib2
#from urllib2 import Request, urlopen, URLError
#import urllib.request
import requests
#import urllib.
import os
from bs4 import BeautifulSoup
import time

#os.environ['http_proxy'] = '127.0.0.1'


#Create a new directory to put the files into
#Get the current working directory and create a new directory in it named test
cwd = os.getcwd()
newdir = cwd +"\\test"
print("The current Working directory is " + cwd)
os.mkdir(newdir);
print("Created new directory " + newdir)
newfile = open('zipfiles.txt','w')
print(newfile)


print("Running script.. ")
#Set variable for page to be open and url to be concatenated 
#http://trademarks.reedtech.com/downloads/TrademarkDailyXML/2017/apc171219.zip
url = "http://trademarks.reedtech.com/"
page = requests.get('http://trademarks.reedtech.com/tmappxml.php#2017')
c = page.content

#File extension to be looked for. 
extension = ".zip"

#Use BeautifulSoup to clean up the page
soup = BeautifulSoup(c)
soup.prettify()

#Find all the links on the page that end in .zip
for anchor in soup.findAll('a[href^="downloads/Trademark"]'):
    links = url + anchor['href']
    if links.endswith(extension):
        newfile.write(links + '\n')
newfile.close()

#Read what is saved in zipfiles.txt and output it to the user
#This is done to create presistent data 
newfile = open('zipfiles.txt', 'r')
for line in newfile:
    print(line + '/n')
newfile.close()

#Read through the lines in the text file and download the zip files.
#Handle exceptions and print exceptions to the console
with open('zipfiles.txt', 'r') as url:
    for line in url:
        if line:
            try:
                ziplink = line
                #Removes the first 48 characters of the url to get the name of the file
                zipfile = line[64:]
                #Removes the last 4 characters to remove the .zip
                zipfile2 = zipfile[:4]
                print("Trying to reach " + ziplink)
                response = requests.get(ziplink)
            except URLError as e:
                if hasattr(e, 'reason'):
                    print('We failed to reach a server.')
                    print('Reason: ', e.reason)
                    continue
                elif hasattr(e, 'code'):
                    print('The server couldn\'t fulfill the request.')
                    print('Error code: ', e.code)
                    continue
            else:
                zipcontent = response.read()
                completeName = os.path.join(newdir, zipfile2+ ".zip")
                with open (completeName, 'w') as f:
                    print("downloading.. " + zipfile)
                    f.write(zipcontent)
                    f.close()
print("Script completed")