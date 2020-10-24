import numpy as np
import pandas as pd
from constants import ORGANISATION, ATTENDEE
import os
from flask import Flask, request, jsonify, make_response, abort
from flask_sqlalchemy import SQLAlchemy
from flask_migrate import Migrate
from flask_restful import Resource, Api
from flask_jwt_extended import create_access_token, jwt_required, get_raw_jwt
from flask_jwt_extended import JWTManager
from werkzeug.security import safe_str_cmp
import dateutil.parser
import datetime
import urllib
from getAadharData import getAadharData
from aadhar_verification import aadharNumVerify
from flask_mail import Mail,Message
import pickle
from textblob import TextBlob
import cv2
import face_recognition
from recommend import getSimilarUsers
from recommend import contentBasedRecommendations

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

app.config['MAIL_SERVER'] = 'smtp.gmail.com'
app.config['MAIL_PORT'] = 587
app.config['MAIL_USE_TLS'] = True
app.config['MAIL_USERNAME'] = 'rpk.happenings@gmail.com'
app.config['MAIL_PASSWORD'] = 'Happenings123'
app.config['MAIL_DEFAULT_SENDER'] = 'rpk.happenings@gmail.com'
app.config['MAIL_ASCII_ATTACHMENTS'] = False
app.config['MAIL_MAX_EMAILS'] = None
mail = Mail(app)

########################## MODELS ################################


registration = db.Table('registration',
                        db.Column('attendee_id', db.Integer, db.ForeignKey(
                            'attendee.id'), nullable=False),
                        db.Column('event_id', db.Integer, db.ForeignKey('event.id'), nullable=False))

class Status(db.Model):

    __tablename__ = 'status'
    id = db.Column(db.Integer, primary_key=True)
    attendee_id = db.Column(db.Integer, nullable=False)
    attendee_name = db.Column(db.String(100), nullable=False)
    event_id = db.Column(db.Integer, nullable=False)
    status = db.Column(db.Boolean,default = False)
    unique_key = db.Column(db.String(10))

    def __init__(self, attendee_id, attendee_name, event_id, status, unique_key):
        self.attendee_id = attendee_id
        self.attendee_name = attendee_name
        self.event_id = event_id
        self.status = status
        self.unique_key = unique_key

class User(db.Model):
    __abstract__ = True

    username = db.Column(db.String(20), nullable=False)
    password = db.Column(db.String(20), nullable=False)
    address = db.Column(db.Text, nullable=False)
    phone = db.Column(db.String(10), nullable=False)
    email_id = db.Column(db.String(50), nullable=False)
    image = db.Column(db.Text, nullable=False)

    def __init__(self, username, password, address, phone, email_id, image):
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
    age = db.Column(db.Integer, nullable=False)
    gender = db.Column(db.String(10), nullable=False)
    events = db.relationship(
        'Event', secondary=registration, backref=db.backref('attendees', lazy=True))
    favourites = db.relationship('Favourites', backref='attendees')
    reviews = db.relationship('Reviews', backref='attendees')
    verification_image = db.Column(db.Text)

    def __init__(self, username, password, address, phone, email_id, image, name, age, gender):
        super().__init__(username, password, address, phone, email_id, image)

        self.name = name
        self.age = age
        self.gender = gender

    def get_userdetails(self, user):

        events = user.events
        reviews = user.reviews
        favourites = user.favourites

        favourite_list = []
        attended_events_data = []
        reviews_list = []

        for event in events:
            e = addEvent(event)
            attended_events_data.append(e)

        for rev in reviews:
            reviews_list.append(addEvent(rev))

        user_dict = {
            'id': user.id,
            'name': user.name,
            'phone': user.phone,
            'image': user.image,
            'address': user.address,
            'email_id': user.email_id,
            'password': user.password,
            'username': user.username,
            'age': user.age,
            'gender': user.gender,
            'verification_img':user.verification_image }

        for favourite in favourites:
            event_id = favourite.event_id
            event = Event.query.filter_by(id=event_id).first()
            favourite_list.append(addEvent(event))

        return {
            'user_details': user_dict,
            'events': attended_events_data,
            'reviews': reviews_list,
            'favourites': favourite_list
        }


def getPieData(events):  # categories vs events

    data = dict()
    for event in events:
        cat = event.category
        if cat not in data:
            data[cat] = 0

        data[cat] = data[cat] + 1

    categories = []
    events = []
    for category, eventCount in data.items():
        categories.append(category)
        events.append(eventCount)
    data.clear()
    data['labels'] = categories
    data['data'] = events

    del categories
    del events

    return data


def getLineData(events):  # attendees vs events
    data = dict()
    eventNames = []
    eventCount = []
    for event in events:
        eventNames.append(event.title)
        eventCount.append(event.current_count)

    data['labels'] = eventNames
    data['data'] = eventCount

    del eventNames
    del eventCount

    return data


def getBarDataCategories(events):  # attendees vs categories
    data = dict()
    label_data = dict()
    for event in events:
        if event.category not in label_data:
            label_data[event.category] = 0
        label_data[event.category] += int(event.current_count)

    eventCat = []
    eventCount = []
    for key in label_data:
        eventCat.append(key)
        eventCount.append(label_data[key])

    data['labels'] = eventCat
    data['data'] = eventCount

    del eventCat
    del eventCount

    return data


def getBarDataReviews(events):  # events vs reviews
    data = dict()
    eventNames = []
    positive = []
    negative = []
    for event in events:
        reviews = event.reviews
        pos = 0
        neg = 0
        for review in reviews:
            sentiment = review.sentiment
            if 'positive' in sentiment.lower():
                pos += 1
            if 'negative' in sentiment.lower():
                neg += 1

        eventNames.append(event.title)
        positive.append(pos)
        negative.append(neg)

    data['labels'] = eventNames
    data['positive'] = positive
    data['negative'] = negative

    del eventNames
    del positive
    del negative

    return data


class Organisation(User):
    __tablename__ = 'organisation'

    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(100), nullable=False)
    subscription = db.Column(db.Boolean,  nullable=False, default=False)
    org_details = db.Column(db.Text, nullable=False)
    events = db.relationship('Event', backref='organisation')

    def __init__(self, username, password, address, phone, email_id, image, name, subscription, org_details):
        super().__init__(username, password, address, phone, email_id, image)

        self.name = name
        self.subscription = subscription
        self.org_details = org_details

    def get_orgdetails(self, organisation):
        events = organisation.events
        events_data = []
        attendees = 0
        reviews = 0
        revenue = 0
        pieData = getPieData(events)
        reviewGraph = getBarDataReviews(events)
        catGraph = getBarDataCategories(events)
        lineGraph = getLineData(events)

        for event in events:
            e = addEvent(event)
            events_data.append(e)
            attendees += len(event.attendee)
            reviews += len(event.reviews)

            revenue += len(event.attendees) * event.entry_amount

        user_dict = {
            'id': organisation.id,
            'name': organisation.name,
            'phone': organisation.phone,
            'image': organisation.image,
            'address': organisation.address,
            'email_id': organisation.email_id,
            'password': organisation.password,
            'username': organisation.username,
            'subscription': organisation.subscription,
            'details': organisation.org_details}

        return {
            "user_details": user_dict,
            "events": events_data,
            "no_of_events": len(events),
            "attendees": attendees,
            "reviews": reviews,
            "revenue": revenue,
            'pie_data': pieData,
            'reviewGraph': reviewGraph,
            'catGraph': catGraph,
            'lineGraph': lineGraph
        }


class Event(db.Model):
    __tablename__ = 'event'

    id = db.Column(db.Integer, primary_key=True)
    title = db.Column(db.String(100), nullable=False)
    description = db.Column(db.Text, nullable=False)
    start_date = db.Column(db.DateTime, nullable=False)
    end_date = db.Column(db.DateTime, nullable=False)
    location = db.Column(db.Text, nullable=False)
    category = db.Column(db.String(100), nullable=False)
    speciality = db.Column(db.Text, nullable=False)
    entry_amount = db.Column(db.Integer, nullable=False)
    max_count = db.Column(db.Integer, nullable=False)
    current_count = db.Column(db.Integer, nullable=False)
    attendee = db.relationship(
        'Attendee', secondary=registration, backref=db.backref('event', lazy=True))
    image = db.Column(db.Text, nullable=False)
    organiser_id = db.Column(db.Integer, db.ForeignKey('organisation.id'))
    reviews = db.relationship('Reviews', backref='event')

    def __init__(self, title, description, start_date, end_date, location, category, speciality, entry_amount, image, organiser_id, current_count, max_count):
        self.title = title
        self.description = description
        self.location = location
        self.category = category
        self.speciality = speciality
        self.entry_amount = entry_amount
        self.image = image
        self.start_date = start_date
        self.end_date = end_date
        self.organiser_id = organiser_id
        self.current_count = current_count
        self.max_count = max_count


class Reviews(db.Model):
    __tablename__ = 'reviews'

    id = db.Column(db.Integer, primary_key=True)
    attendee_id = db.Column(db.Integer, db.ForeignKey(
        'attendee.id'), nullable=False)
    event_id = db.Column(db.Integer, db.ForeignKey('event.id'), nullable=False)
    review = db.Column(db.Text, nullable=False)
    rating = db.Column(db.Integer, nullable=False)
    sentiment = db.Column(db.String(20), nullable=False)

    def __init__(self, event_id, attendee_id, review, rating, sentiment):

        self.event_id = event_id
        self.attendee_id = attendee_id
        self.review = review
        self.rating = rating
        self.sentiment = sentiment


class Favourites(db.Model):
    __tablename__ = 'favourites'

    id = db.Column(db.Integer, primary_key=True)
    attendee_id = db.Column(db.Integer, db.ForeignKey(
        'attendee.id'), nullable=False)
    event_id = db.Column(db.Integer, nullable=False)

    def __init__(self, attendee_id, event_id):
        self.attendee_id = attendee_id
        self.event_id = event_id


def addToDatabase(objectname):
    db.session.add(objectname)
    db.session.commit()


def deleteFromDatabase(objectname):
    db.session.delete(objectname)
    db.session.commit()

#####################  API'S  ########################

class FaceRecognition(Resource):

    def post(self, event_id):

        
        event = Event.query.get(event_id)
        attendees = event.attendee
        encodeList = []
        nameList = []
        ids = []
        # print(attendees)
        for attendee in attendees:
            url = attendee.image
            url_response = urllib.request.urlopen(url)
            img_array = np.array(bytearray(url_response.read()), dtype=np.uint8)
            img = cv2.imdecode(img_array, -1)
            encode = face_recognition.face_encodings(img)[0]
            encodeList.append(encode)
            nameList.append(attendee.name)
            ids.append(attendee.id)
        # print(encodeList)
        data = request.get_json()
        url = data["url"]
        url_response = urllib.request.urlopen(url)
        img_array = np.array(bytearray(url_response.read()), dtype=np.uint8)
        img = cv2.imdecode(img_array, -1)
        facesCurFrame = face_recognition.face_locations(img)
        encodingsCurFrame = face_recognition.face_encodings(img,facesCurFrame)
        name = ""
        for encodeFace, faceLoc in zip(encodingsCurFrame, facesCurFrame):
            matches = face_recognition.compare_faces(encodeList, encodeFace)
            dist = face_recognition.face_distance(encodeList, encodeFace)
            print(matches)
            print(dist)

            matchIndex = np.argmin(dist)

            if matches[matchIndex]:
                name = nameList[matchIndex].upper()
                attendee_status = Status.query.filter_by(event_id = event_id,attendee_id = ids[matchIndex]).first()
                attendee_status.status = True
                db.session.commit()
            else:
                name = "Unknown"

        result = dict()

        if name == "Unknown":
            result["message"] = "Attendee not found in registered list"
            result["name"] = "Unknown"
        
        else:
            result["message"] = "Attendee present in registered list"
            result["name"] = name
        
        
        del facesCurFrame
        del encodingsCurFrame
        del img
        del img_array
        del encodeList
        del nameList

        return result

    def get(self, event_id):

        # event = Event.query.get(event_id)
        # attendees = event.attendee
        attendees = Status.query.filter_by(event_id = event_id).all()
        # encodeList = []
        nameList = []
        statusList = []
        # imageUrls = []
        for entry in attendees:
            # url = attendee.image
            # imageUrls.append(url)
            # url_response = urllib.request.urlopen(url)
            # img_array = np.array(bytearray(url_response.read()), dtype=np.uint8)
            # img = cv2.imdecode(img_array, -1)
            # encode = face_recognition.face_encodings(img)[0]
            # encodeList.append(encode.tolist())
            nameList.append(entry.name)
            statusList.append(entry.status)

        # print(encodeList)
        print(nameList)
        data = dict()
        # data["encodings"] = encodeList
        data["names"] = nameList
        data['status'] = statusList
        # data['imageUrls'] = imageUrls

        # del encodeList
        del nameList
        del statusList
        return data

class AadharApi(Resource):
    def post(self):
        data = request.get_json()
        print(data)
        url = data["url"]
        url_response = urllib.request.urlopen(url)
        img_array = np.array(bytearray(url_response.read()), dtype=np.uint8)
        img = cv2.imdecode(img_array, -1)
        #cv2.imshow("OCR", img)
        text = pytesseract.image_to_string(img)
        print(text)
        aadharData = getAadharData(text)
        print(aadharData)
        verification = aadharNumVerify(aadharData["Aadhar"])
        print(verification)
        # cv2.imshow("OCR", img)
        # cv2.waitKey(0)
        return {"verification": verification, 'aadhar_details': aadharData}


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
        del user

        return {'message': 'User created successfully'}

class UserLogin(Resource):

    def post(self):
        data = request.get_json()
        print(data)
        if data['type'] == ATTENDEE:
            user = Attendee.query.filter_by(username=data['username']).first()
        elif data['type'] == ORGANISATION:
            user = Organisation.query.filter_by(
                username=data['username']).first()

        if user is None:
            return {'message': 'User doesn\'t exist.'}
        if user and safe_str_cmp(user.password, data['password']):
            access_token = create_access_token(
                identity=user.id, expires_delta=datetime.timedelta(hours=300))
            #refresh_token = create_refresh_token(user.id)
            return {
                'access_token': access_token,
                'id': user.id,
            }, 200
        return {"message": 'Invalid credentials'}, 401


def addEvent(row):
    d = {}
    for column in row.__table__.columns:
        d[column.name] = str(getattr(row, column.name))
    return d

class GetEvent(Resource):

    def get(self, event_id):
        # data = request.get_json()
        # event_id = int(data['event_id'])
        event = Event.query.filter_by(id = event_id).first()
        print(event)
        e = addEvent(event)
        attendees = event.attendee
        reviews = event.reviews
        attendeesList = []
        reviewList = []
        for attendee in attendees:
            attendeesList.append(addEvent(attendee))
        for review in reviews:
            reviewList.append(addEvent(review))
        e["attendees"] = attendeesList
        e["reviews"] = reviewList

        del attendeesList
        del reviewList

        return e


class EventApi(Resource):

    def post(self):

        data = request.get_json()
        event = Event(
            title=data["title"],
            description=data["description"],
            start_date=dateutil.parser.parse(data["start_date"]),
            end_date=dateutil.parser.parse(data["end_date"]),
            category=data["category"],
            speciality=data["speciality"],
            entry_amount=data["entry_amount"],
            image=data["image"],
            location=data["location"],
            organiser_id=data['org_id'],
            current_count=0,
            max_count=data['max_count']
        )
        addToDatabase(event)
        return addEvent(event)

    def put(self):
        data = request.get_json()
        event_id = data["event_id"]
        event = Event.query.get(event_id)
        event.title = data["title"]
        event.description = data["description"]
        event.start_date = dateutil.parser.parse(data["start_date"])
        event.end_date = dateutil.parser.parse(data["end_date"])
        event.location = data["location"]
        event.category = data["category"]
        event.speciality = data["speciality"]
        event.entry_amount = data["entry_amount"]
        event.image = data["image"]
        event.current_count = data['current_count']
        event.max_count = data['max_count']
        db.session.commit()
        return addEvent(event)

    def delete(self):
        pass


class ClassicGet(Resource):
    def get(self, type, id, resource):
        data = request.get_json()
        #type = data['type']
        #resource = data['resource']
        print(type, resource, id)

        if type == ATTENDEE:
            user = Attendee.query.get(id)
            if resource == "favs":
                d = user.favourites
            elif resource == 'reviews':
                d = user.reviews
            elif resource == 'registeredevents':
                d = user.events
            elif resource == 'popular_events':
                events = Event.query.all()
                eventList = {}
                for event in events:
                    attendees = len(event.attendee)
                    eventList[event] = attendees

                eventList = {k: v for k, v in sorted(
                    eventList.items(), key=lambda item: item[1])}
                user_events = user.events
                count = 0
                d = []
                for event in eventList:
                    if event not in user_events:
                        d.append(event)
                        count += 1

                    if count == 10:
                        break
        else:
            user = Organisation.query.get(id)
            if resource == "events":
                d = user.events
        l = []
        for item in d:
            l.append(addEvent(item))

        del d
        return l


class Events(Resource):

    def get(self):
        events = Event.query.all()

        events_json = []
        for event in events:
            events_json.append(addEvent(event))

        return events_json


class UserDetails(Resource):
    def get(self, user_id, type):
        if type == ATTENDEE:
            user = Attendee.query.get(user_id)
            print(user)
            details = user.get_userdetails(user)
            del user
        else:
            organisation = Organisation.query.filter_by(id=user_id).first()
            details = organisation.get_orgdetails(organisation)
            del organisation

        return details

    def put(self, user_id, type):
        data = request.get_json()
        if type == ATTENDEE:
            user = Attendee.query.get(user_id)
            user.name = data['name']
            user.phone = data['phone']
            user.image = data['image']
            user.address = data['address']
            user.email_id = data['email_id']
            user.password = data['password']
            user.username = data['username']
            user.age = data['age']
            user.gender = data['gender']

        else:
            user = Organisation.query.get(user_id)
            user.name = data['name']
            user.phone = data['phone']
            user.image = data['image']
            user.address = data['address']
            user.org_details = data["details"]
            user.email_id = data['email_id']
            user.password = data['password']
            user.username = data['username']

        db.session.commit()
        return addEvent(user)


class ManageReviews(Resource):

    def post(self, user_id):

        data = request.get_json()
        polarity = TextBlob(data['review']).polarity
        print(polarity)
        #polarity = sum(polarities)/len(polarities)
        # review = ""
        if polarity >= -1 and polarity < -0.6:
            review = "Strongly Negative"
        elif polarity >= -0.6 and polarity < -0.2:
            review = "Slightly Negative"
        elif polarity >= -0.2 and polarity < 0.2:
            review = "Neutral"
        elif polarity >= 0.2 and polarity < 0.6:
            review = "Slightly Positive"
        else:
            review = "Strongly Positive"
        print(review)
        reviews = Reviews(
            event_id=data['event_id'],
            attendee_id=user_id,
            review=data['review'],
            rating=data['rating'],
            sentiment=review
        )

        addToDatabase(reviews)
        del reviews
        del polarity
        del review

        return {"message": "Review Added"}


class ManageFavourites(Resource):

    def post(self, user_id, event_id):
        favourite = Favourites(user_id, event_id)
        addToDatabase(favourite)
        del favourite
        return {'message': 'Favourite added'}

    def delete(self, user_id, event_id):
        favourite = Favourites.query.filter_by(
            attendee_id=user_id, event_id=event_id).first()
        deleteFromDatabase(favourite)
        del favourite
        return {'message': 'Favourite removed'}

class Subscription(Resource):
    def post(self, org_id):
        org = Organisation.query.get(org_id)
        org.subscription = True
        db.session.commit()
        del org
        return {"message":"Subscribed"}

class RegisterForEvent(Resource):
    def post(self, user_id, event_id):
        #data = request.get_json()
        #img = data["url"]
        user = Attendee.query.get(user_id)
        #user.verification_image = img
        event = Event.query.get(event_id)
        event.attendee.append(user)
        event.current_count = int(event.current_count) + 1

        status = Status(
            attendee_id=user_id,
            attendee_name = user.name,
            event_id=event_id,
            status=False,
            unique_key=str(event_id)
        )
        addToDatabase(status)
        db.session.commit()
        body = 'Your unique id is ' + \
            str(event.id) + ', for ' + event.title + \
            '\non : ' + \
            event.start_date.strftime('%d %B, %Y') + \
            '\nVenue: ' + event.location
        msg = Message(subject='Event Confirmation from Happenings',
                      body=body, recipients=[user.email_id])
        mail.send(msg)
        
        return {'message': 'Successfully registered for Event'}

class GetOrg(Resource):
    
    def get(self, org_id):
        org = Organisation.query.get(org_id)
        return {"org_name" : org.name}


class UserLogout(Resource):

    @jwt_required
    def post(self):
        jti = get_raw_jwt()['jti']
        BLACKLIST.append(jti)
        return {"message": "Successfully logged out"}, 200


class Recommend(Resource):
    def get(self, type, user_id, event_id):
        events = Event.query.all()
        content = {}

        if type.lower() == 'content_based':
            events = []
            categories = []
            locations = []
            for e in events:
                if (e.start_date - datetime.now()).minutes > 0:
                    events.append({ e.id : {"location" : e.location, 'category' : e.category,'startdate' : str(e.start_date.day),'enddate' : str(e.end_date.day),'cost' : e.entry_amount}})
                    if e.location not in locations:
                        locations.append(e.location)
                    if e.category not in categories:
                        categories.append(e.category)
            content_based_recommendations_ids = contentBasedRecommendations(events, locations, categories, event_id, 3)
            content_based_recommendations_events = []
            for id in content_based_recommendations_ids:
                e1 = Event.query.get(id)
                content_based_recommendations_events.append(addEvent(e1))

            return {'recommended_events' : content_based_recommendations_events}

        else : 
            users = Attendee.query.all()
            user_id = []
            user_events = []
            user_ratings = []
            for u in users:
                user_reviews = u.reviews
                for e in user_reviews :
                    user_id.append(e.attendee_id)
                    user_events.append(e.event_id)
                    user_ratings.append(e.rating)
            data = {
                "userID" : user_id,
                "eventID" : user_events,
                "rating" : user_ratings
            }
            attendee_sim = Attendee.query.filter_by(user_id=user_id).first()
            attendee_events = []
            attendee_events = attendee_sim.events
            recommended_events = []
            similar_users = getSimilarUsers(data,3,user_id)
            for sim in similar_users:
                attendee = Attendee.query.filter_by(user_id = sim).first()
                sim_user_events = attendee.events
                for e in sim_user_events:
                    if e not in attendee_events and (e.start_date - datetime.now()).minutes > 0 :
                        recommended_events.append(addEvent(e))

            return {
                "recommended_events" : recommended_events,
            }
        # return {
        #     "userID" : user_id,
        #     "eventID" : user_events,
        #     "rating" : user_ratings,
        #     "events" : events,
        #     "categories" :categories,
        #     "locations" : locations
        # }



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
api.add_resource(UserLogin, "/login")
api.add_resource(AadharApi, '/verification')
api.add_resource(UserRegister, "/register")
api.add_resource(Events, '/events')
api.add_resource(UserDetails, "/<string:type>/<int:user_id>")
api.add_resource(EventApi, '/event')
api.add_resource(RegisterForEvent,
                 '/register_for_event/event/<int:event_id>/user/<int:user_id>')
api.add_resource(ClassicGet, '/<string:type>/<int:id>/<string:resource>')
api.add_resource(ManageReviews, '/add_review/<int:user_id>')
api.add_resource(ManageFavourites,
                 '/add_to_favourite/user/<int:user_id>/event/<int:event_id>')
api.add_resource(GetEvent, '/event/<int:event_id>')

api.add_resource(UserLogout, '/logout')
api.add_resource(FaceRecognition, '/validate_attendee/<int:event_id>')
api.add_resource(Recommend, '/recommedations/<string:type>/<int:user_id>/<int:event_id>')
api.add_resource(Subscription,'/subs/<int:org_id>')
api.add_resource(GetOrg, '/org_name/<int:org_id>')

if __name__ == '__main__':
    app.run(debug=True)


# raw_data = {
#     'userID': [1, 1, 1, 1, 2, 2, 2, 2, 2, 3, 3, 3, 3 ],
#     'eventID': [1, 3, 6, 4, 1, 4, 6, 7, 10, 1, 4, 6, 8],
#     'rating': [5, 4, 2, 3, 1, 5, 5, 2, 4, 5, 5, 4, 2]
# }

# content based raw data = 
# 1) Dict of events = {
    # 'id' : {
    #     'location' : 'hjv',
    #     'category' : 'hsd',
    #     'startdate' : ,
    #     'enddate' : ,
    #     'cost' : 
    # }
# }
# 2) List of categories
# 3) list of locations
# locations = ['Borivali','Kandivali','Malad','Goregaon','Andheri','Bandra','Dadar']


# import pandas as pd
# import heapq
# from surprise import KNNBasic
# from surprise import Reader, Dataset

# def getSimilarUsers(data,n,user_id)
#     df = pd.DataFrame(data)
#     reader = Reader()
#     data = Dataset.load_from_df(df[['userID', 'eventID', 'rating']], reader)
#     trainSet = data.build_full_trainset()
#     sim_options = {'name': 'cosine','user_based': True}
#     model = KNNBasic(sim_options=sim_options)
#     model.fit(trainSet)
#     simsMatrix = model.compute_similarities()
#     testUserInnerID = trainSet.to_inner_uid(user_id)
#     similarityRow = simsMatrix[testUserInnerID]
#     similarUsers = []
#     for innerID, score in enumerate(similarityRow):
#         if (innerID != testUserInnerID):
#             similarUsers.append( (innerID, score) )
#     kNeighbors = heapq.nlargest(n, similarUsers, key=lambda t: t[1])
#     similarUsers=[]
#     for simUser in kNeighbors:
#         similarUsers.append(simUser[0])
    
#     return similarUsers