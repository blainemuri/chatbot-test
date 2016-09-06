import sys
import json
from watson_developer_cloud import ConversationV1

#Connect to Watson Conversation
#Get response back for dialog

conversation = ConversationV1(
  username='b42cc929-33b8-462c-9cf7-d42cba172c56',
  password='CXMTz6p7nv2w',
  version='2016-07-11'
)
workspace_id = 'bcee86e6-d69c-4eb9-be40-a3ce769450df'
context = {}
watson_response = {}
user_input = sys.argv[1]

#Get initial response from Watson
initial_request = conversation.message(
        workspace_id = workspace_id,
        message_input = {'text': ''},
        context = context
)

#Use context from initial response
context = initial_request["context"]

user_input = sys.argv[1]

watson_response =  conversation.message(
        workspace_id = workspace_id,
        message_input = {'text': user_input},
        context = context
    )

#Do something with the response (in JSON format)
print (json.dumps(watson_response, indent=2))

# Example Response:
# {
#   "input": {
#     "text": "Turn on the lights"
#   },
#   "alternate_intents": false,
#   "context": {
#     "conversation_id": "f1ab5f76-f41b-47b4-a8dc-e1c32b925b79",
#     "system": {
#       "dialog_stack": [
#         "root"
#       ],
#       "dialog_turn_counter": 1,
#       "dialog_request_counter": 1
#     },
#     "defaultCounter": 0
#   },
#   "entities": [
#     {
#       "entity": "appliance",
#       "location": [12, 18],
#       "value": "light"
#     }
#   ],
#   "intents": [
#     {
#       "intent": "turn_on",
#       "confidence": 0.8362587462307721
#     }
#   ],
#   "output": {
#     "text": [
#       "Hi. It looks like a nice drive today. What would you like me to do?"
#     ],
#     "nodes_visited": [
#       "node_1_1467221909631"
#     ]
#   }
# }
