var redux = require('redux');
var oldState = {
    userDetails: {},
    events: [],
    loading: true,
    eventMap: {},
    pieData: {},
    lineData: {},
    reviewData: {},
    catData: {},

}

const reducer = (state = oldState, action) => {
    //Các case sẽ thực hiện update các thuộc tính tương ứng
    switch (action.type) {
        case "USER_INFO":
            return { ...state }
        case "GET_DATA":
            let events = action.payload.events
            let eventMap = {}
            for (let index = 0; index < action.payload.events.length; index++) {
                eventMap[events[index].id] = index
            }

            return {
                ...state,
                pieData: action.payload.pie_data,
                lineData: action.payload.lineGraph,
                reviewData: action.payload.reviewGraph,
                catData: action.payload.catGraph,
                events: action.payload.events,
                user_details: action.payload.user_details,
                loading: false,
                eventMap: eventMap,
                noOfEvents: action.payload.no_of_events,
                attendees: action.payload.attendees,
                revenue: action.payload.revenue,
                reviews: action.payload.reviews
            };
        default:
            return state
    }
}
var store = redux.createStore(reducer);
export default store;