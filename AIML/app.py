from flask import Flask, request, jsonify
import aiml
import os
from datetime import datetime


kernel = aiml.Kernel()


def chatbot():
    # Create the kernel and learn AIML files
    kernel.learn("std-startup.xml")
    kernel.respond("load aiml b")
    time = datetime.now()
    timestamp = time.strftime("%d/%m/%Y %H:%M:%S")
    with open('record.txt', 'a') as record:
        record.write('session ' + timestamp)


def setPredicates():
    if os.path.isfile('predicate.txt'):
        with open('predicate.txt', 'r') as predicateread:
            k = predicateread.read().splitlines()
        predicates = [(k[2 * i], k[2 * i + 1]) for i in range(int(len(k) / 2))]
        print("Predicates:", predicates)

        if len(predicates) != 0:
            for dec in predicates:
                kernel.setPredicate(dec[0], dec[1], sessionID='_global')


app = Flask(__name__)
app.before_first_request(chatbot)


@app.route('/userexists', methods=['GET'])
def userexists():
    if(os.path.exists('predicate.txt')):
        print("exists")
        return "exists"
    else:
        print("not exists")
        return None


@app.route('/signup', methods=['POST'])
def signup():
    formData = request.form
    with open('predicate.txt', 'w') as f:
        f.write(f'name\n')
        f.write(f'{formData["name"]}\n')
        f.write(f'work\n')
        f.write(f'{formData["work"]}\n')
        f.write(f'hobbies\n')
        f.write(f'{formData["hobbies"]}\n')
        f.write(f'father\n')
        f.write(f'{formData["father"]}\n')
        f.write(f'mother\n')
        f.write(f'{formData["mother"]}\n')
        f.write(f'address\n')
        f.write(f'{formData["address"]}\n')
        f.write(f'fathersnum\n')
        f.write(f'{formData["fathermobile"]}\n')
        f.write(f'mothersnum\n')
        f.write(f'{formData["mothermobile"]}\n')
        f.write(f'doctorsnum\n')
        f.write(f'{formData["doctormobile"]}\n')
        f.write(f'bloodg\n')
        f.write(f'{formData["bloodgroup"]}\n')

    setPredicates()
    print("chatbot done ")
    return "success"


@app.route('/<string:query>')
def respond(query):
    with open('record.txt', 'a') as record:
        timestamp = datetime.now().strftime("%H:%M:%S")
        record.write('user @ ' + timestamp + ' : ' + query + '\n')
        #query = query.replace("'", "")
        botans = str(kernel.respond(query))

        timestamp = datetime.now().strftime("%H:%M:%S")
        record.write('bot  @ ' + timestamp + ' : ' + botans + '\n\n')
    return botans
