import sys, json, argparse

parser = argparse.ArgumentParser()
parser.add_argument('--image', dest="image", type=str, nargs='?', const='')
parser.add_argument('--api-host', dest='api_host', type=str, nargs='?', const='')
parser.add_argument('--db', dest='db', type=str, nargs='?', const='')

db        = parser.parse_args().db
api_host  = parser.parse_args().api_host
new_image = parser.parse_args().image

task_def = json.load(sys.stdin)['taskDefinition']['containerDefinitions']

if db:
    task_def[0]['environment'] = [{ "name": "DB", "value": db }]
if api_host:
    task_def[0]['environment'] = [{ "name": "API_HOST", "value": api_host }]
if new_image:
    task_def[0]['image'] = new_image

print(json.dumps(task_def))

