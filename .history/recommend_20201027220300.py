import pandas as pd
import heapq
from surprise import KNNBasic
from surprise import Reader, Dataset

def getSimilarUsers(data,n,user_id):
    if user_id not in data['userID']:
        return []
    df = pd.DataFrame(data)
    reader = Reader()
    data = Dataset.load_from_df(df[['userID', 'eventID', 'rating']], reader)
    trainSet = data.build_full_trainset()
    sim_options = {'name': 'cosine','user_based': True}
    model = KNNBasic(sim_options=sim_options)
    model.fit(trainSet)
    simsMatrix = model.compute_similarities()
    testUserInnerID = trainSet.to_inner_uid(user_id)
    similarityRow = simsMatrix[testUserInnerID]
    similarUsers = []
    for innerID, score in enumerate(similarityRow):
        if (innerID != testUserInnerID):
            similarUsers.append( (innerID, score) )
    kNeighbors = heapq.nlargest(n, similarUsers, key=lambda t: t[1])
    similarUsers=[]
    for simUser in kNeighbors:
        similarUsers.append(simUser[0])
    return similarUsers

weekDays = ['Mon','Tue','Wed','Thu','Fri','Sat','Sun']

def contentBasedRecommendations(events, locations, categories, event_id, n):
    rows = []
    rows += locations + categories + weekDays + weekDays
    rows.append('Cost')
    all_events = []
    for id, event in events.items():
        e = getEventList(event['location'], event['category'], event['cost'], event['startdate'], event['enddate'], locations, categories)
        all_events.append((id, e))
    if len(all_events) > 0:
        print("all events not zero")
        data = pd.DataFrame(all_events[0][1], rows, [all_events[0][0]])
        for i in range(1, len(all_events)):
            data[all_events[i][0]] = all_events[i][1]
        recommended_events = getRecommendations(data, event_id, all_events, n)
        return [event[0] for event in recommended_events]
    else:
        print("all events is zero")
        return []

def getRecommendations(data, event_id, all_events, n):

    corr_data = data.corr()['event_id']
    cols = list(data.columns)
    sim_events = []

    for i in range(len(cols)):
        id = cols[i]
        if id != event_id:
            print("Corr value : {}".format(corr_data[id]))
            if corr_data[id] > 0.4:
                sim_events.append((id, corr_data[id]))
        
    nMostSimilarEvents = heapq.nlargest(n, sim_events, key=lambda t: t[1])
    return nMostSimilarEvents

def getEventList(location, category, cost, startdate, enddate, locations, categories):
    event1 = []
    
    loc = [0] * len(locations)
    index = locations.index(location)
    loc[index] = 1
    
    cat = [0] * len(categories)
    index = categories.index(category)
    cat[index] = 1
    
    cost /= 2000
    
    start = [0] * len(weekDays)
    index = weekDays.index(startdate)
    start[index] = 1
    
    end = [0] * len(weekDays)
    index = weekDays.index(enddate)
    end[index] = 1

    event1 += loc + cat + start + end
    event1.append(cost)
    return event1