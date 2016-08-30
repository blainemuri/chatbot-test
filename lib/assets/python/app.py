import time
import web
import json
import thesaurus
from watson_developer_cloud import ConversationV1

conversation = ConversationV1(
  username='b42cc929-33b8-462c-9cf7-d42cba172c56',
  password='CXMTz6p7nv2w',
  version='2016-07-11'
)
workspace_id = 'bcee86e6-d69c-4eb9-be40-a3ce769450df'
context = {}

file = open('docs/logs.txt', 'a')
file.write("Logs Date & Time: " + time.strftime("%c") + '\n')

initial_request = conversation.message(
        workspace_id = workspace_id,
        message_input = {'text': ''},
        context = context
)
watson_req = {}

context = initial_request["context"]

urls = (
  '/hello', 'Index'
)

app = web.application(urls, globals())

render = web.template.render('templates/', base="layout")

file_name = time.strftime("%c")
path_name = 'docs/' + file_name + '.txt'
file = open(path_name, 'w')

class Index(object):
    def GET(self):
        return render.hello_form()

    def POST(self):
        form = web.input(input="Hello")
        userInput = "%s" % (form.input)

        file.write("Input: " + userInput + '\n')

        watson_req = conversation.message(
            workspace_id = workspace_id,
            message_input = {'text': userInput},
            context = context
        )

        index = 0
        checkString = watson_req["intents"][0]["intent"]
        if(checkString == "show_pleasure" or checkString == "bad_chips" or checkString == "find_nutrition"):
            index = 1

        file.write("Output: " + json.dumps(watson_req["output"]["text"][index]) + '\n')
        return render.index(output = json.dumps(watson_req["output"]["text"][index]))

if __name__ == "__main__":
    app.run()
    file.close()