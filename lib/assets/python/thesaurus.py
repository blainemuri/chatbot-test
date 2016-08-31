import json
import sys
from urllib2 import Request, urlopen, URLError

#does not include dicitonary.com as thesaurus option.
userWord = sys.argv[1]
urlBase = 'http://words.bighugelabs.com/api/2/'
apikey = 'cfc03924dbd107a919561369d751cb42/'
req_url = urlBase+apikey+userWord+'/'
syn = []
divider = 0
num_words = 0
dummy_string = ""

try:
	request = Request(req_url)
	response = urlopen(request)
	text_response = response.read()
	error = 0
except URLError, e:
	error = 1

if error == 0:
	for i in range(0, len(text_response)):
		if text_response[i] == '|':
			divider += 1
			if divider == 2:
				i += 1
				num_words += 1
				dummy_string = ""
				while text_response[i] != '\n':
					dummy_string += text_response[i]
					i += 1
				syn.append(dummy_string)	
				divider = 0

	for j in range(0, num_words):
		print syn[j]

else:
	print 'Word not found.'