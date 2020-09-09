import numpy as np
import pandas as pd
from constants import ORGANISATION, ATTENDEE
import os
from flask import Flask, request, jsonify, make_response, abort
from flask_sqlalchemy import SQLAlchemy
from flask_migrate import Migrate
from flask_restful import Resource, Api
#from functools import wraps
#from flask_jwt import JWT, jwt_required, current_identity
from flask_jwt_extended import create_access_token, jwt_required, get_raw_jwt
from flask_jwt_extended import JWTManager
from werkzeug.security import safe_str_cmp

import datetime

app = Flask(__name__)
app.config['SECRET_KEY'] = 'assembler'

basedir = os.path.abspath(os.path.dirname(__file__))
app.config['SQLALCHEMY_DATABASE_URI'] = os.environ.get('DATABASE_URL', 'sqlite:///' +
                                                       os.path.join(basedir, 'data.sqlite'))

app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

db = SQLAlchemy(app)
Migrate(app, db)

# we can also use app.secret like before, Flask-JWT-Extended can recognize both
app.config['JWT_SECRET_KEY'] = 'chariyo'
app.config['JWT_BLACKLIST_ENABLED'] = True  # enable blacklist feature
# allow blacklisting for access and refresh tokens
app.config['JWT_BLACKLIST_TOKEN_CHECKS'] = ['access']
jwt = JWTManager(app)


########### MODELS ##########

registration = db.Table('registration',
        db.Column('attendee_id', db.Integer, db.ForeignKey('attendee.id'), nullable = False ),
        db.Column('event_id', db.Integer, db.ForeignKey('event.id'), nullable = False ),
        db.Column('unique_key', db.Text, nullable = False),
        db.Column('status',db.String(6), nullable = False ))

class User(db.Model):
    __abstract__ = True

    username = db.Column(db.String(20), nullable = False)
    password = db.Column(db.String(20), nullable = False)
    address = db.Column(db.Text,nullable = False)
    phone = db.Column(db.Integer, nullable = False)
    email_id = db.Column(db.String(50),nullable = False)
    image = db.Column(db.Text, nullable = False)
    
    def __init__(self, username, password,address,phone,email_id,image):
        self.username = username
        self.password = password
        self.address = address
        self.phone = phone
        self.email_id = email_id
        self.image = image
        

class Attendee(User):
    __tablename__ = 'attendee'

    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(100), nullable=False)
    age = db.Column(db.Integer, nullable = False)
    gender = db.Column(db.String(10), nullable=False)
    events = db.relationship('Event',secondary=registration, backref = db.backref('attendees', lazy = True))
    favourites = db.relationship('Favourites',backref='attendees')
    reviews = db.relationship('Reviews',backref='attendees')
    
    def __init__(self, username, password, address, phone, email_id, image, name, age, gender):
        super().__init__(username, password, address, phone, email_id, image)

        self.name = name
        self.age = age
        self.gender = gender
    

class Organisation(User):
    __tablename__ = 'organisation'

    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(100), nullable=False)
    subscription = db.Column(db.Boolean,  nullable=False, default=False)
    org_details = db.Column(db.Text, nullable = False)
    events = db.relationship('Event',backref='organisation')

    def __init__(self, username, password, address, phone, email_id, image, name, subscription, org_details):
        super().__init__(username, password, address, phone, email_id, image)

        self.name = name
        self.subscription = subscription
        self.org_details = org_details
    

class Event(db.Model):
    __tablename__ = 'event'

    id = db.Column(db.Integer,primary_key=True)
    title = db.Column(db.String(100),nullable=False)
    description = db.Column(db.Text,nullable=False)
    start_date = db.Column(db.DateTime,nullable=False)
    end_date = db.Column(db.DateTime,nullable=False)
    location = db.Column(db.Text, nullable=False)
    category = db.Column(db.String(100), nullable=False)
    speciality = db.Column(db.Text, nullable=False)
    entry_amount = db.Column(db.Integer, nullable=False)
    attendee = db.relationship('Attendee',secondary=registration, backref = db.backref('event', lazy = True))
    image = db.Column(db.Text, nullable = False)
    organiser_id = db.Column(db.Integer,db.ForeignKey('organisation.id'))
    reviews = db.relationship('Reviews',backref='event')

    def __init__(self, title, description, start_date, end_date, location, category, speciality, entry_amount, image, organiser_id):
        self.title = title
        self.description = description
        self.location = location
        self.category = category
        self.speciality = speciality
        self.entry_amount = entry_amount
        self.image = image
        self.start_date = start_date
        self.end_date = end_date

        
   
class Reviews(db.Model):
    __tablename__ = 'reviews'

    id = db.Column(db.Integer,primary_key=True)
    attendee_id = db.Column(db.Integer,db.ForeignKey('attendee.id'), nullable=False)
    event_id = db.Column(db.Integer,db.ForeignKey('event.id'), nullable=False)
    review = db.Column(db.Text, nullable=False)
    rating = db.Column(db.Integer, nullable=False)
    
    def __init__(self, event_id, attendee_id, review, rating):
        
        self.event_id = event_id
        self.attendee_id = attendee_id
        self.review = review
        self.rating = rating
        

class Favourites(db.Model):
    __tablename__ = 'favourites'

    id = db.Column(db.Integer,primary_key=True)
    attendee_id = db.Column(db.Integer,db.ForeignKey('attendee.id'), nullable=False)
    event_id = db.Column(db.Integer,nullable=False)

    def __init__(self, attendee_id, event_id):
        self.attendee_id = attendee_id
        self.event_id = event_id


def addToDatabase(objectname):
    db.session.add(objectname)
    db.session.commit()






#####################  API'S  ########################

class UserRegister(Resource):
    
    def post(self):
        data = request.get_json()

        
        if data['type'] == ATTENDEE:
            user = Attendee(
                name=data['name'], 
                username=data['username'], 
                password=data['password'],
                address=data['address'],
                phone=data['phone'],
                email_id=data['email_id'],
                image=data['image'],
                age=data['age'],
                gender=data['gender'])

        elif data['type'] == ORGANISATION:
            user = Organisation(
                name=data['name'], 
                username=data['username'], 
                password=data['password'],
                address=data['address'],
                phone=data['phone'],
                email_id=data['email_id'],
                image=data['image'],
                subscription=False,
                org_details=data['details'])
        
        addToDatabase(user)

        return {'message': 'User created successfully'}



class UserLogin(Resource):

    def post(self):
        data = request.get_json()

        if data['type'] == ATTENDEE:
            user = Attendee.query.filter_by(username=data['username']).first()
        elif data['type'] == ORGANISATION:
            user = Organisation.query.filter_by(username=data['username']).first()
            
        if user is None:
            return {'message': 'User doesn\'t exist.'}
        if user and safe_str_cmp(user.password, data['password']):
            access_token = create_access_token(
                identity=user.id, expires_delta=datetime.timedelta(hours=30))
            #refresh_token = create_refresh_token(user.id)
            return {
                'access_token': access_token,
                'id': user.id,
            }, 200
        return {"message": 'Invalid credentials'}, 401

class UserDetails(Resource):
    
    def get(self, user_id, type):

        if type == ATTENDEE:
            user = Attendee.query.get(user_id)
            events = user.events
            reviews = user.reviews
            favourites = user.favourites
            
            favourite_list = []
            attended_events_data=[]
            reviews_list = []
            
            for event in events:
                attended_events_data.append({
                    'id' : event.id,
                    'title' :event.title,
                    'description' :event.description,
                    'start_date' :event.start_date,
                    'end_date' :event.end_date,
                    'location' :event.location,
                    'category':event.category,
                    'speciality' :event.speciality,
                    'entry_amount':event.entry_amount,
                    'image':event.image,
                    'org_name': event.organisation.name
                })
            
            for rev in reviews:
                reviews_list.append({'review': rev.review,
                                 'rating': rev.rating,})
            
            user_dict = {'name': user.name,
                        'phone': user.phone,
                        'image': user.image,
                        'address': user.address,
                        'email_id': user.email_id,
                        'password': user.password,
                        'username': user.username,
                        'age':user.age,
                        'gender': user.gender}
                        
            
            for favourite in favourites:
                event_id = favourite.event_id
                event = Event.query.filter_by(id = event_id).first()
                favourite_list.append({
                    'id' : event.id,
                    'title' :event.title,
                    'description' :event.description,
                    'start_date' :event.start_date,
                    'end_date' :event.end_date,
                    'location' :event.location,
                    'category':event.category,
                    'speciality' :event.speciality,
                    'entry_amount':event.entry_amount,
                    'image':event.image,
                    'org_name': event.organisation.name
                })

            return {
                'user_details' : user_dict,
                'events' : attended_events_data,
                'reviews' : reviews_list,
                'favourites' : favourite_list
            }

        else :
            organisation = Organisation.query.get(id = user_id).first()

            events = organisation.events
            events_data=[]
            
            for event in events:
                events_data.append({
                    'id' : event.id,
                    'title' :event.title,
                    'description' :event.description,
                    'start_date' :event.start_date,
                    'end_date' :event.end_date,
                    'location' :event.location,
                    'category':event.category,
                    'speciality' :event.speciality,
                    'entry_amount':event.entry_amount,
                    'image':event.image,
                    'org_name': event.organisation.name
                })
            
            user_dict = {'name': user.name,
                        'phone': user.phone,
                        'image': user.image,
                        'address': user.address,
                        'email_id': user.email_id,
                        'password': user.password,
                        'username': user.username,
                        'subscription':user.subscription,
                        'details': user.org_details}
                        
            return {
                "user_details" : user_dict,
                "events" : events_data
            }


@jwt.token_in_blacklist_loader
def check_if_token_in_blacklist(decrypted_token):
    return decrypted_token['jti'] in BLACKLIST


@jwt.expired_token_loader
def expired_token_callback():
    return jsonify({
        'message': 'The token has expired.',
        'error': 'token_expired'
    }), 401


@jwt.invalid_token_loader
# we have to keep the argument here, since it's passed in by the caller internally
def invalid_token_callback(error):
    return jsonify({
        'message': 'Signature verification failed.',
        'error': 'invalid_token'
    }), 401


@jwt.unauthorized_loader
def missing_token_callback(error):
    return jsonify({
        "description": "Request does not contain an access token.",
        'error': 'authorization_required'
    }), 401


# @jwt.needs_fresh_token_loader
# def token_not_fresh_callback():
#     return jsonify({
#         "description": "The token is not fresh.",
#         'error': 'fresh_token_required'
#     }), 401


@jwt.revoked_token_loader
def revoked_token_callback():
    return jsonify({
        "description": "The token has been revoked.",
        'error': 'token_revoked'
    }), 401


BLACKLIST = []

# @app.before_first_request
# def create_tables():
#     db.create_all()

api = Api(app)
api.add_resource(UserDetails ,"/<string:type>/<int:user_id>")
api.add_resource(UserRegister, "/register")
api.add_resource(UserLogin, "/login")

if __name__ == '__main__':
    app.run(debug=True)












