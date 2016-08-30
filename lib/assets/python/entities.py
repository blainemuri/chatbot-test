import json
import time
import lxml.etree as etree
from urllib2 import Request, urlopen, URLError
from xml.dom import minidom

def thesaurus():
	file_name = time.strftime("%c")
	thesaurus_type = raw_input("Would you like to use dictionary.com (0) or bighugelabs.com (1)? ")
	path_name = 'docs/' + file_name + '.txt'
	file = open(path_name, 'w')
	entitiy_name = ""
	value_name = ""
	num_entities = 0
	num_values = 0

	while entitiy_name != 'x':
		value_name = ""
		num_entities += 1
		entitiy_name = raw_input("What is the name of your entity? (Press 'x' to finish) ")
		if entitiy_name == 'x':
			break

		file.write("Entity: " + entitiy_name + '\n')

		while value_name != 'q':
			num_values += 1
			value_name = raw_input("What is the value that you would like to get synonyms for? (Press 'q' to finish) ")
			if value_name == 'q':
				break
			file.write("Value: " + value_name + '\n')

			if(thesaurus_type == '0'):
				urlBase = 'http://www.dictionaryapi.com/api/v1/references/thesaurus/xml/'
				apikey = '7cfb5c3f-dbc5-4444-bdb2-93cec6177375'
				word = value_name
				req_url = urlBase+word+'?key='+apikey

				request = Request(req_url)
				response = urlopen(request)
				xml_response = response.read()
				xmldoc = minidom.parse(xml_response)
				itemlist = xmldoc.getElementsByTagName('term')
				tree = etree.XML(xml_response)
				print etree.tostring(tree, pretty_print = True)

			else:
				urlBase = 'http://words.bighugelabs.com/api/2/'
				apikey = 'cfc03924dbd107a919561369d751cb42/'
				word = value_name
				req_url = urlBase+apikey+word+'/'
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

					file.write("There are " + str(num_words) + " synonyms for " + word + ". Here they are: \n")
					for j in range(0, num_words):
						file.write(syn[j] + '\n')

				else:
					file.write("Word not found. \n")
					print "Error, word not found!"

	file.close()