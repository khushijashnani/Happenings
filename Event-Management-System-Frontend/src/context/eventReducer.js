
export default (state, action) => {
    switch (action.type) {
        case "GET_DATA":
            console.log(action.payload)
            return {
                ...state,
                events: action.events,
                user_details: action.user_details,
                loading: false
            };

        default:
            return {
                state
            };
    }
};
